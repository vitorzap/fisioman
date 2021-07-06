import 'package:fisioman/data/dummy_data2.dart';
import 'package:flutter/material.dart';
import '../utils/db_utils.dart';

enum WeekDay { Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday }

final WeekDayList = [
  DropdownMenuItem<WeekDay>(value: WeekDay.Sunday, child: Text('Domingo')),
  DropdownMenuItem<WeekDay>(value: WeekDay.Monday, child: Text('Segunda')),
  DropdownMenuItem<WeekDay>(value: WeekDay.Tuesday, child: Text('Terça')),
  DropdownMenuItem<WeekDay>(value: WeekDay.Wednesday, child: Text('Quarta')),
  DropdownMenuItem<WeekDay>(value: WeekDay.Thursday, child: Text('Quinta')),
  DropdownMenuItem<WeekDay>(value: WeekDay.Friday, child: Text('Sexta')),
  DropdownMenuItem<WeekDay>(value: WeekDay.Saturday, child: Text('Sabado')),
];

enum HourDay {
  h04m00,
  h04m30,
  h05m00,
  h05m30,
  h06m00,
  h06m30,
  h07m00,
  h07m30,
  h08m00,
  h08m30,
  h09m00,
  h09m30,
  h10m00,
  h10m30,
  h11m00,
  h11m30,
  h12m00,
  h12m30,
  h13m00,
  h13m30,
  h14m00,
  h14m30,
  h15m00,
  h15m30,
  h16m00,
  h16m30,
  h17m00,
  h17m30,
  h18m00,
  h18m30,
  h19m00,
  h19m30,
  h20m00,
  h20m30,
  h21m00,
  h21m30,
  h22m00,
  h22m30,
  h23m00,
  h23m30,
}

final HourDayList = [
  DropdownMenuItem<HourDay>(value: HourDay.h04m00, child: Text('04:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h04m30, child: Text('04:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h05m00, child: Text('05:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h05m30, child: Text('05:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h06m00, child: Text('06:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h06m30, child: Text('06:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h07m00, child: Text('07:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h07m30, child: Text('07:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h08m00, child: Text('08:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h08m30, child: Text('08:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h09m00, child: Text('09:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h09m30, child: Text('09:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h10m00, child: Text('10:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h10m30, child: Text('10:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h11m00, child: Text('11:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h11m30, child: Text('11:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h12m00, child: Text('12:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h12m30, child: Text('12:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h13m00, child: Text('13:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h13m30, child: Text('13:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h14m00, child: Text('14:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h14m30, child: Text('14:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h15m00, child: Text('15:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h15m30, child: Text('15:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h16m00, child: Text('16:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h16m30, child: Text('16:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h17m00, child: Text('17:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h17m30, child: Text('17:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h18m00, child: Text('18:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h18m30, child: Text('18:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h19m00, child: Text('19:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h19m30, child: Text('19:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h20m00, child: Text('20:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h20m30, child: Text('20:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h21m00, child: Text('21:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h21m30, child: Text('21:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h22m00, child: Text('22:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h22m30, child: Text('22:30')),
  DropdownMenuItem<HourDay>(value: HourDay.h23m00, child: Text('23:00')),
  DropdownMenuItem<HourDay>(value: HourDay.h23m30, child: Text('23:30')),
];

class SessionDay {
  final int id;
  final int clientId;
  final WeekDay day;
  final HourDay hour;

  SessionDay({
    this.id,
    this.clientId,
    this.day,
    this.hour,
  });

  String get dayText {
    switch (day) {
      case WeekDay.Sunday:
        return "Domingo";
      case WeekDay.Monday:
        return "Segunda";
      case WeekDay.Tuesday:
        return "Terça";
      case WeekDay.Wednesday:
        return "Quarta";
      case WeekDay.Thursday:
        return "Quinta";
      case WeekDay.Friday:
        return "Sexta";
      case WeekDay.Saturday:
        return "Sabado";
      default:
        return "*";
    }
  }
}

class SessionDays with ChangeNotifier {
  // List<SessionDay> _items = [];
  List<SessionDay> _items = DUMMY_SDAYS;

  List<SessionDay> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadSessionDays() async {
    final rowList = await DbUtil.getAllData('sessiondays', 'day,hour');
    _items = rowList
        .map(
          (row) => SessionDay(
            id: row['id'],
            clientId: row['clientId'],
            day: WeekDay.values[row['day']],
            hour: HourDay.values[row['hour']],
          ),
        )
        .toList();

    notifyListeners();

    return Future.value();
  }

  // Future<void> loadSessionByDay() async {
  //   final rowList = await DbUtil.rawQuery(
  //       'SELECT DAY, HOUR, NAME FROM sessiondays ' +
  //           'INNER JOIN clients ON sessiondays.clientId = clients.id ' +
  //           'ORDER BY DAY, HOUR, NAME');
  //   _items = rowList
  //       .map(
  //         (row) => SessionDay(
  //           id: row['id'],
  //           clientId: row['clientId'],
  //           day: WeekDay.values[row['day']],
  //           hour: HourDay.values[row['hour']],
  //         ),
  //       )
  //       .toList();

  //   notifyListeners();

  //   return Future.value();
  // }

  Future<void> addSessionDay(SessionDay newSessionDay) async {
    int newId = await DbUtil.insert('sessiondays', {
      'clientId': newSessionDay.clientId,
      'day': newSessionDay.day.index,
      'hour': newSessionDay.hour.index,
    });
    SessionDay workSessionDay = new SessionDay(
      id: newId,
      clientId: newSessionDay.clientId,
      day: newSessionDay.day,
      hour: newSessionDay.hour,
    );
    _items.add(workSessionDay);

    notifyListeners();
  }

  Future<void> deleteSessionDay(int id) async {
    final index = _items.indexWhere((sessionDay) => sessionDay.id == id);

    if (index >= 0) {
      final sessionDay = _items[index];
      DbUtil.delete('sessiondays', sessionDay.id);
      _items.remove(sessionDay);
      notifyListeners();
    }
  }

  Future<void> deleteClientSessionDays(int clientId) async {
    _items.removeWhere((sessionDay) => sessionDay.clientId == clientId);
    DbUtil.deleteByCondition('sessiondays', 'clientId', clientId);
    notifyListeners();
  }
}
