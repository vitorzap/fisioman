import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/payments.dart';
import '../utils/db_utils.dart';

class Payments with ChangeNotifier {
  List<Payment> _items = [];

  List<Payment> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOpenPayments() async {
    final rowList = await DbUtil.rawQuery(
        'SELECT payments.ID,CLIENTID, NAME, EXPECTEDDATE, EFFECTIVEDATE, VALUE FROM payments ' +
            'INNER JOIN clients ON payments.clientId = clients.id ' +
            'WHERE EFFECTIVEDATE IS NULL ' +
            'ORDER BY EXPECTEDDATE, NAME');
    _items = rowList
        .map(
          (row) => Payment(
            id: row['id'],
            clientId: row['clientId'],
            name: row['name'],
            expectedDate: row['expectedDate'] == null
                ? null
                : DateTime.parse(row['expectedDate']),
            effectiveDate: row['effectiveDate'] == null
                ? null
                : DateTime.parse(row['effectiveDate']),
            amount: row['value'],
          ),
        )
        .toList();

    notifyListeners();

    return Future.value();
  }

  Future<void> loadPaymentsByClient(int clientId) async {
    final rowList = await DbUtil.rawQuery(
        'SELECT payments.ID, CLIENTID, clients.NAME, EXPECTEDDATE, EFFECTIVEDATE, VALUE FROM payments ' +
            'INNER JOIN clients ON payments.clientId = clients.id ' +
            '  WHERE clientId = $clientId ' +
            'ORDER BY EXPECTEDDATE DESC ');
    _items = rowList
        .map(
          (row) => Payment(
            id: row['id'],
            clientId: row['clientId'],
            name: row['name'],
            expectedDate: row['expectedDate'] == null
                ? null
                : DateTime.parse(row['expectedDate']),
            effectiveDate: row['effectiveDate'] == null
                ? null
                : DateTime.parse(row['effectiveDate']),
            amount: row['value'],
          ),
        )
        .toList();

    notifyListeners();

    return Future.value();
  }

  Future<void> addPayment(Payment newPayment) async {
    int newId = await DbUtil.insert('payments', {
      'clientId': newPayment.clientId,
      'expectedDate': newPayment.expectedDate.toIso8601String(),
      'effectiveDate': newPayment.effectiveDate == null
          ? null
          : newPayment.effectiveDate.toIso8601String(),
      'value': newPayment.amount,
    });
    Payment workPayment = new Payment(
      id: newId,
      name: newPayment.name,
      clientId: newPayment.clientId,
      expectedDate: newPayment.expectedDate,
      effectiveDate: newPayment.effectiveDate,
      amount: newPayment.amount,
    );
    _items.add(workPayment);

    notifyListeners();
  }

  Future<void> updateDateEffective(int id, String date) async {
    if (id == null) {
      return;
    }
    final index = _items.indexWhere((item) => item.id == id);

    if (index >= 0) {
      Payment updatedPayment = new Payment(
        id: _items[index].id,
        clientId: _items[index].clientId,
        name: _items[index].name,
        expectedDate: _items[index].expectedDate,
        effectiveDate:
            date == null ? null : DateFormat("dd/MM/yyyy").parse(date),
        amount: _items[index].amount,
      );
      _items[index] = updatedPayment;

      DbUtil.update(
          'payments',
          {
            'id': updatedPayment.id,
            'clientId': updatedPayment.clientId,
            'expectedDate': updatedPayment.expectedDate.toIso8601String(),
            'effectiveDate': updatedPayment.effectiveDate == null
                ? null
                : updatedPayment.effectiveDate.toIso8601String(),
            'value': updatedPayment.amount,
          },
          id);

      notifyListeners();
    }
  }

  Future<void> updateDateEffectiveAndExcludeFromList(
      int id, String date) async {
    if (id == null) {
      return;
    }
    if (date == null) {
      return;
    }
    final index = _items.indexWhere((item) => item.id == id);

    if (index >= 0) {
      DbUtil.update(
          'payments',
          {
            'id': _items[index].id,
            'clientId': _items[index].clientId,
            'expectedDate': _items[index].expectedDate.toIso8601String(),
            'effectiveDate':
                DateFormat("dd/MM/yyyy").parse(date).toIso8601String(),
            'value': _items[index].amount,
          },
          id);
      _items.remove(_items[index]);

      notifyListeners();
    }
  }

  Future<void> deletePayment(int id) async {
    final index = _items.indexWhere((payment) => payment.id == id);

    if (index >= 0) {
      final payment = _items[index];
      _items.remove(payment);
      DbUtil.delete('payments', payment.id);
      notifyListeners();
    }
  }
}
