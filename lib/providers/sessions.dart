import 'package:fisioman/models/enums/hour_day.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/utils/utils.dart';
import '../models/sessions.dart';
import '../utils/db_utils.dart';
import '../models/enums/payment_status.dart';

class Sessions with ChangeNotifier {
  List<Session> _items = [];
  // List<Session> _items = DUMMY_SESSIONS;

  List<Session> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOpenSessions() async {
    final rowList = await DbUtil.rawQuery(
        'SELECT sessions.ID,CLIENTID, NAME, DATETIME, EFFECTED, PAID, PAYMENTID FROM sessions ' +
            'INNER JOIN clients ON sessions.clientId = clients.id ' +
            'WHERE EFFECTED = 0 ' +
            'ORDER BY EFFECTED, NAME');
    _items = rowList
        .map(
          (row) => Session(
            id: row['id'],
            clientId: row['clientId'],
            name: row['name'],
            dateTime: DateTime.parse(row['dateTime']),
            effected: row['effected'] == 1 ? true : false,
            paid: PaymentStatus.values[row['paid']],
            paymentId: row['paymentId'],
          ),
        )
        .toList();

    notifyListeners();

    return Future.value();
  }

  Future<void> loadSessionsByClient(int clientId) async {
    final rowList = await DbUtil.rawQuery(
        'SELECT sessions.ID,CLIENTID, NAME, DATETIME, EFFECTED, PAID, PAYMENTID,IDAUTO FROM sessions ' +
            'INNER JOIN clients ON sessions.clientId = clients.id ' +
            '  WHERE clientId = $clientId ' +
            'ORDER BY DATETIME DESC ');
    _items = rowList
        .map(
          (row) => Session(
            id: row['id'],
            clientId: row['clientId'],
            name: row['name'],
            dateTime: DateTime.parse(row['dateTime']),
            effected: row['effected'] == 1 ? true : false,
            paid: PaymentStatus.values[row['paid']],
            paymentId: row['paymentId'],
            idAuto: row['idAuto'],
          ),
        )
        .toList();

    notifyListeners();

    return Future.value();
  }

  Future<void> loadSessionsByDate(DateTime date) async {
    final sDateI =
        date.toIso8601String().substring(0, 10) + new String.fromCharCode(0x41);
    final sDateF =
        date.toIso8601String().substring(0, 10) + new String.fromCharCode(0xFF);

    final rowList = await DbUtil.rawQuery(
        'SELECT sessions.ID,CLIENTID, NAME, DATETIME, EFFECTED, PAID, PAYMENTID, IDAUTO FROM sessions ' +
            'INNER JOIN clients ON sessions.clientId = clients.id ' +
            '  WHERE DATETIME > "$sDateI" AND DATETIME < "$sDateF" ' +
            'ORDER BY DATETIME DESC ');
    _items = rowList
        .map(
          (row) => Session(
            id: row['id'],
            clientId: row['clientId'],
            name: row['name'],
            dateTime: DateTime.parse(row['dateTime']),
            effected: row['effected'] == 1 ? true : false,
            paid: PaymentStatus.values[row['paid']],
            paymentId: row['paymentId'],
            idAuto: row['idAuto'],
          ),
        )
        .toList();

    notifyListeners();

    return Future.value();
  }

  Future<void> addSession(Session newSession) async {
    int newId = await DbUtil.insert('sessions', {
      'clientId': newSession.clientId,
      'dateTime': newSession.dateTime.toIso8601String(),
      'effected': newSession.effected ? 1 : 0,
      'paid': newSession.paid.index,
    });
    Session workSession = new Session(
      id: newId,
      name: newSession.name,
      clientId: newSession.clientId,
      dateTime: newSession.dateTime,
      effected: newSession.effected,
      paid: newSession.paid,
    );
    _items.add(workSession);

    notifyListeners();
  }

  Future<void> updateStatus(
      int id, bool newEffectd, PaymentStatus newPaid) async {
    if (id == null) {
      return;
    }
    final index = _items.indexWhere((item) => item.id == id);

    int paymentId = _items[index].paymentId;
    if (paymentId != null && paymentId != 0) {
      if (newPaid == PaymentStatus.NotPaid) {
        paymentId = null;
      }
    }

    if (index >= 0) {
      Session updatedSession = new Session(
        id: _items[index].id,
        clientId: _items[index].clientId,
        name: _items[index].name,
        dateTime: _items[index].dateTime,
        effected: newEffectd,
        paid: newPaid,
        paymentId: paymentId,
        idAuto: _items[index].idAuto,
      );
      _items[index] = updatedSession;

      DbUtil.update(
          'sessions',
          {
            'id': updatedSession.id,
            'clientId': updatedSession.clientId,
            'dateTime': updatedSession.dateTime.toIso8601String(),
            'effected': updatedSession.effected ? 1 : 0,
            'paid': updatedSession.paid.index,
            'paymentId': updatedSession.paymentId,
            'idAuto': updatedSession.idAuto,
          },
          id);

      notifyListeners();
    }
  }

  Future<void> updatePaymentId(int payId) {
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].paid == PaymentStatus.ToSchedule) {
        Session workSession = new Session(
          id: _items[i].id,
          clientId: _items[i].clientId,
          name: _items[i].name,
          dateTime: _items[i].dateTime,
          effected: _items[i].effected,
          paid: PaymentStatus.Scheduled,
          paymentId: payId,
          idAuto: _items[i].idAuto,
        );
        _items[i] = workSession;
      }
    }
    notifyListeners();

    return Future.value();
  }

  Future<void> deleteSession(int id) async {
    final index = _items.indexWhere((session) => session.id == id);

    if (index >= 0) {
      final session = _items[index];
      _items.remove(session);
      DbUtil.delete('sessions', session.id);
      notifyListeners();
    }

    return Future.value();
  }

  Future<int> generateSessions(DateTime initialDate, DateTime finalDate) async {
    final topRow = await DbUtil.rawQuery(
        'SELECT IDAUTO FROM sessions ORDER BY IDAUTO DESC LIMIT 1');
    var idAuto = 0;
    if (topRow.length == 0) {
      idAuto = 1;
    } else {
      if (topRow[0]['idAuto'] == null) {
        idAuto = 1;
      } else {
        idAuto = topRow[0]['idAuto'] + 1;
      }
    }

    final rowList = await DbUtil.rawQuery(
        'SELECT CLIENTID, DAY, HOUR FROM sessiondays ORDER BY DAY, HOUR, CLIENTID');
    int noGenerated = 0;
    rowList.forEach((row) {
      var rowClient = row['clientId'];
      var rowDay = row['day'];
      var rowHour = formatedHour(HourDay.values[row['hour']].toString());

      var iDate = initialDate;

      var i = 1;
      var wDate = iDate;
      while (wDate.isBefore(finalDate)) {
        if (wDate.weekday == rowDay) {
          var sDate = wDate.toIso8601String().substring(0, 10) +
              ' ' +
              rowHour +
              ':00.000';

          DbUtil.insert('sessions', {
            'clientId': rowClient,
            'dateTime': DateTime.parse(sDate).toIso8601String(),
            'effected': 0,
            'paid': PaymentStatus.NotPaid.index,
            'idAuto': idAuto,
          });

          noGenerated++;
          i = 7;
        }
        wDate = wDate.add(Duration(days: i));
      }
    });
    return noGenerated;
  }

  Future<int> deleteSessions() async {
    final topRow = await DbUtil.rawQuery(
        'SELECT IDAUTO FROM sessions ORDER BY IDAUTO DESC LIMIT 1');
    var idAuto = 0;
    if (topRow.length == 0) {
      return 0;
    } else {
      if (topRow[0]['idAuto'] == null) {
        return 0;
      } else {
        idAuto = topRow[0]['idAuto'];
      }
    }
    final noEfetivadas = firstIntValue(await DbUtil.rawQuery(
        'SELECT COUNT(*) FROM sessions WHERE IDAUTO = $idAuto AND effected = 1'));

    if (noEfetivadas > 0) {
      return -1;
    }
    final noDeleted =
        await DbUtil.rawDelete('DELETE FROM sessions WHERE IDAUTO = $idAuto');

    return noDeleted;
  }
}
