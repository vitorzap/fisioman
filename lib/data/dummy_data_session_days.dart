import '../providers/session_days.dart';
import '../models/session_days.dart';
import '../models/enums/week_day.dart';
import '../models/enums/hour_day.dart';

final DUMMY_SDAYS = [
  SessionDay(
    id: 1,
    clientId: 1,
    day: WeekDay.Tuesday,
    hour: HourDay.h07m00,
  ),
  SessionDay(
    id: 2,
    clientId: 1,
    day: WeekDay.Thursday,
    hour: HourDay.h07m00,
  ),
  SessionDay(
    id: 3,
    clientId: 2,
    day: WeekDay.Monday,
    hour: HourDay.h07m00,
  ),
  SessionDay(
    id: 4,
    clientId: 2,
    day: WeekDay.Wednesday,
    hour: HourDay.h07m00,
  ),
  SessionDay(
    id: 5,
    clientId: 2,
    day: WeekDay.Friday,
    hour: HourDay.h07m00,
  ),
];
