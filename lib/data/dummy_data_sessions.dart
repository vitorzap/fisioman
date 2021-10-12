import '../models/sessions.dart';
import '../models/enums/payment_status.dart';

final DUMMY_SESSIONS = [
  Session(
      id: 1,
      name: 'Joao',
      dateTime: DateTime.parse('2021-06-02 10:00:00'),
      effected: false,
      paid: PaymentStatus.NotPaid),
  Session(
      id: 2,
      name: 'Marcos',
      dateTime: DateTime.parse('2021-08-02 12:00:00'),
      effected: false,
      paid: PaymentStatus.NotPaid),
];
