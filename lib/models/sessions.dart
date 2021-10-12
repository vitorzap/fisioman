import './enums/payment_status.dart';

class Session {
  final int id;
  final int clientId;
  final String name;
  final DateTime dateTime;
  final bool effected;
  final PaymentStatus paid;
  final int paymentId;
  final int idAuto;

  Session({
    this.id,
    this.clientId,
    this.name,
    this.dateTime,
    this.effected,
    this.paid,
    this.paymentId,
    this.idAuto,
  });
}
