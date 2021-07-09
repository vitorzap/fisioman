import '../models/enums/week_day.dart';
import '../models/enums/hour_day.dart';

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
