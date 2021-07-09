import 'package:flutter/material.dart';
import '../utils/db_utils.dart';
import '../models/enums/week_day.dart';
import '../models/enums/hour_day.dart';
import '../models/session_by_day.dart';

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
