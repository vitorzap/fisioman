import 'package:fisioman/models/enums/payment_status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/payments.dart';
import '../utils/db_utils.dart';
import 'package:sqflite/sqflite.dart' as sql;

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

  Future<int> addPaymentFromSessions(Payment newPayment) async {
    sql.Database db = await DbUtil.getDB();

    int newId;

    await db.transaction((txn) async {
      newId = await txn.rawInsert(
          'INSERT INTO payments(clientId, expectedDate, effectiveDate, value) ' +
              'VALUES( ' +
              newPayment.clientId.toString() +
              ' , "' +
              newPayment.expectedDate.toIso8601String() +
              '", null,  ' +
              newPayment.amount.toString() +
              ' )');
      await txn.rawUpdate('UPDATE sessions SET paymentId = ' +
          newId.toString() +
          ', paid = ' +
          PaymentStatus.Scheduled.index.toString() +
          ' WHERE clientId = ' +
          newPayment.clientId.toString() +
          ' AND paid = ' +
          PaymentStatus.ToSchedule.index.toString());
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
    return newId;
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

      sql.Database db = await DbUtil.getDB();

      await db.transaction((txn) async {
        txn.update(
            'payments',
            {
              'effectiveDate': updatedPayment.effectiveDate == null
                  ? null
                  : updatedPayment.effectiveDate.toIso8601String(),
            },
            where: 'id = ?',
            whereArgs: [id]);

        txn.update(
            'sessions',
            {
              'paid': date == null
                  ? PaymentStatus.Scheduled.index
                  : PaymentStatus.Paid.index
            },
            where: 'paymentId = ?',
            whereArgs: [id]);
      });
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
      sql.Database db = await DbUtil.getDB();

      await db.transaction((txn) async {
        txn.update(
            'payments',
            {
              'effectiveDate':
                  DateFormat("dd/MM/yyyy").parse(date).toIso8601String(),
            },
            where: 'id = ?',
            whereArgs: [id]);

        txn.update(
            'sessions',
            {
              'paid': PaymentStatus.Paid.index,
            },
            where: 'paymentId = ?',
            whereArgs: [id]);
      });
      notifyListeners();
    }
  }

  Future<void> deletePayment(int id) async {
    final rowList = await DbUtil.getDataByGenericField(
        'sessions', 'paymentId', id.toString(), 'id');
    final index = _items.indexWhere((payment) => payment.id == id);
    final payment = _items[index];
    _items.remove(payment);

    if (index >= 0) {
      if (rowList.length == 0) {
        DbUtil.delete('payments', payment.id);
      } else {
        sql.Database db = await DbUtil.getDB();
        await db.transaction((txn) async {
          await txn.delete('payments', where: 'Id = ?', whereArgs: [id]);

          await txn.rawUpdate('UPDATE sessions SET paymentId = null' +
              ', paid = ' +
              PaymentStatus.NotPaid.index.toString() +
              ' WHERE paymentId = ' +
              id.toString());
        });
      }
      notifyListeners();
      return;
    }
  }
}
