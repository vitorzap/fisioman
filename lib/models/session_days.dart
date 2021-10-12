import '../models/enums/hour_day.dart';
import '../models/enums/week_day.dart';

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
