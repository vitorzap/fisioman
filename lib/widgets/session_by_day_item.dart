import 'package:flutter/material.dart';
import '../models/session_by_day.dart';

class SessionByDayItem extends StatelessWidget {
  final SessionByDay sessionByDay;

  SessionByDayItem(this.sessionByDay);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Text(
            sessionByDay.hour
                .toString()
                .substring(sessionByDay.hour.toString().indexOf('h') + 1)
                .replaceAll("m", ":"),
            style: TextStyle(fontSize: 24)),
        title: Text(sessionByDay.clients.toString().substring(2)));
  }
}
