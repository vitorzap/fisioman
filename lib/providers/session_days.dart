import 'package:fisioman/data/dummy_data_session_days.dart';
import 'package:flutter/material.dart';
import '../utils/db_utils.dart';
import '../models/enums/week_day.dart';
import '../models/enums/hour_day.dart';
import '../models/session_days.dart';

class SessionDays with ChangeNotifier {
  List<SessionDay> _items = [];
  // List<SessionDay> _items = DUMMY_SDAYS;

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
