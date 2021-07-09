import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/checks.dart';
import '../utils/db_utils.dart';

class Checks with ChangeNotifier {
  List<Check> _items = [];
  // List<Check> _items = DUMMY_CHECKS;

  List<Check> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOpenChecks() async {
    final rowList = await DbUtil.rawQuery(
        'SELECT checks.ID,checks.CLIENTID, NAME, PAYMENTID, EXPECTEDDATE, EFFECTIVEDATE, ' +
            'AGREEDDATE, WITHDRAWDATE, NUMBER, checks.VALUE FROM checks ' +
            'INNER JOIN clients ON checks.clientId = clients.id ' +
            'INNER JOIN payments ON checks.paymentId = payments.id ' +
            'WHERE WITHDRAWDATE IS NULL ' +
            'ORDER BY AGREEDDATE, NAME');
    _items = rowList
        .map(
          (row) => Check(
            id: row['id'],
            clientId: row['clientId'],
            name: row['name'],
            paymentId: row['paymentId'],
            expectedDate: row['expectedDate'] == null
                ? null
                : DateTime.parse(row['expectedDate']),
            effectiveDate: row['effectiveDate'] == null
                ? null
                : DateTime.parse(row['effectiveDate']),
            agreedDate: row['agreedDate'] == null
                ? null
                : DateTime.parse(row['agreedDate']),
            withdrawDate: row['withdrawDate'] == null
                ? null
                : DateTime.parse(row['withdateDate']),
            number: row['number'],
            value: row['value'],
          ),
        )
        .toList();

    notifyListeners();

    return Future.value();
  }

  Future<void> loadChecksByPayment(int paymentId) async {
    final rowList = await DbUtil.rawQuery(
        'SELECT checks.ID, checks.CLIENTID, NAME, PAYMENTID, EXPECTEDDATE, EFFECTIVEDATE, ' +
            'AGREEDDATE, WITHDRAWDATE, NUMBER, checks.VALUE FROM checks ' +
            'INNER JOIN clients ON checks.clientId = clients.id ' +
            'INNER JOIN payments ON checks.paymentId = payments.id ' +
            '  WHERE checks.paymentId = $paymentId ' +
            'ORDER BY AGREEDDATE DESC ');
    _items = rowList
        .map(
          (row) => Check(
            id: row['id'],
            clientId: row['clientId'],
            name: row['name'],
            paymentId: row['paymentId'],
            expectedDate: row['expectedDate'] == null
                ? null
                : DateTime.parse(row['expectedDate']),
            effectiveDate: row['effectiveDate'] == null
                ? null
                : DateTime.parse(row['effectiveDate']),
            agreedDate: row['agreedDate'] == null
                ? null
                : DateTime.parse(row['agreedDate']),
            withdrawDate: row['withdrawDate'] == null
                ? null
                : DateTime.parse(row['withdrawDate']),
            number: row['number'],
            value: row['value'],
          ),
        )
        .toList();

    notifyListeners();

    return Future.value();
  }

  Future<void> addCheck(Check newCheck) async {
    int newId = await DbUtil.insert('checks', {
      'clientId': newCheck.clientId,
      'paymentId': newCheck.paymentId,
      'number': newCheck.number,
      'agreedDate': newCheck.agreedDate.toIso8601String(),
      'withdrawDate': newCheck.withdrawDate == null
          ? null
          : newCheck.withdrawDate.toIso8601String(),
      'value': newCheck.value,
    });
    Check workCheck = new Check(
      id: newId,
      clientId: newCheck.clientId,
      name: newCheck.name,
      paymentId: newCheck.paymentId,
      expectedDate: newCheck.expectedDate,
      effectiveDate: newCheck.effectiveDate,
      agreedDate: newCheck.agreedDate,
      withdrawDate: newCheck.withdrawDate,
      number: newCheck.number,
      value: newCheck.value,
    );
    _items.add(workCheck);

    notifyListeners();
  }

  Future<void> updateWithdrawDate(int id, String date) async {
    if (id == null) {
      return;
    }
    final index = _items.indexWhere((item) => item.id == id);

    if (index >= 0) {
      Check updatedCheck = new Check(
        id: _items[index].id,
        clientId: _items[index].clientId,
        name: _items[index].name,
        paymentId: _items[index].paymentId,
        expectedDate: _items[index].expectedDate,
        effectiveDate: _items[index].effectiveDate,
        agreedDate: _items[index].agreedDate,
        withdrawDate:
            date == null ? null : DateFormat("dd/MM/yyyy").parse(date),
        number: _items[index].number,
        value: _items[index].value,
      );

      _items[index] = updatedCheck;

      DbUtil.update(
          'checks',
          {
            'id': updatedCheck.id,
            'clientId': updatedCheck.clientId,
            'paymentId': updatedCheck.paymentId,
            'agreedDate': updatedCheck.agreedDate.toIso8601String(),
            'withdrawDate': updatedCheck.withdrawDate == null
                ? null
                : updatedCheck.withdrawDate.toIso8601String(),
            'number': updatedCheck.number,
            'value': updatedCheck.value,
          },
          id);

      notifyListeners();
    }
  }

  Future<void> updateWithdrawDateAndExcludeFromList(int id, String date) async {
    if (id == null) {
      return;
    }
    if (date == null) {
      return;
    }

    final index = _items.indexWhere((item) => item.id == id);

    final dDate = DateFormat("dd/MM/yyyy").parse(date);

    if (index >= 0) {
      DbUtil.update(
          'checks',
          {
            'id': _items[index].id,
            'clientId': _items[index].clientId,
            'paymentId': _items[index].paymentId,
            'agreedDate': _items[index].agreedDate.toIso8601String(),
            'withdrawDate': dDate.toIso8601String(),
            'number': _items[index].number,
            'value': _items[index].value,
          },
          id);
      _items.remove(_items[index]);

      notifyListeners();
    }
  }

  Future<void> deleteCheck(int id) async {
    final index = _items.indexWhere((check) => check.id == id);

    if (index >= 0) {
      final check = _items[index];
      _items.remove(check);
      DbUtil.delete('checks', check.id);
      notifyListeners();
    }
  }
}
