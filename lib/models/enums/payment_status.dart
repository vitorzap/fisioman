enum PaymentStatus { NotPaid, ToSchedule, Scheduled, Paid }

String paymentStatusToText(PaymentStatus paid) {
  switch (paid) {
    case PaymentStatus.NotPaid:
      return 'Pagto pendente';
      break;
    case PaymentStatus.ToSchedule:
      return 'Programar';
      break;
    case PaymentStatus.Scheduled:
      return 'Programado';
      break;
    case PaymentStatus.Paid:
      return 'Pago';
      break;
    default:
      return 'ERRO>paid';
  }
}
