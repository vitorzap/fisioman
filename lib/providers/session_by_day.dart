import 'package:flutter/material.dart';
import '../utils/db_utils.dart';
import '../providers/session_days.dart';

class SessionByDay {
  final WeekDay day;
  final HourDay hour;
  final String clients;

  SessionByDay({
    this.day,
    this.hour,
    this.clients,
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

class SessionsByDay with ChangeNotifier {
  List<SessionByDay> _items = [];

  List<SessionByDay> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadSessionsByDay(WeekDay weekDay) async {
    final rowList = await DbUtil.rawQuery(
        'SELECT DAY, HOUR, NAME FROM sessiondays ' +
            'INNER JOIN clients ON sessiondays.clientId = clients.id ' +
            'WHERE DAY = ${weekDay.index} ' +
            'ORDER BY DAY, HOUR, NAME');

    List<SessionByDay> wSessionsByDay = [];
    if (rowList.length > 0) {
      var lastHour = rowList[0]['hour'];
      var thisHour = 0;
      var allClients = '';
      rowList.forEach((row) {
        thisHour = row['hour'];
        if (thisHour != lastHour) {
          var newSessionByDay = new SessionByDay(
            day: WeekDay.values[row['day']],
            hour: HourDay.values[lastHour],
            clients: allClients,
          );
          wSessionsByDay.add(newSessionByDay);
          allClients = '';
          lastHour = thisHour;
        }
        allClients = allClients + ", " + row['name'];
      });
      var newSessionByDay = new SessionByDay(
        day: WeekDay.values[rowList[rowList.length - 1]['day']],
        hour: HourDay.values[lastHour],
        clients: allClients,
      );
      wSessionsByDay.add(newSessionByDay);
    }
    _items = wSessionsByDay;

    notifyListeners();

    return Future.value();
  }
}
