class Check {
  final int id;
  final int clientId;
  final String name;
  final int paymentId;
  final DateTime expectedDate;
  final DateTime effectiveDate;
  final DateTime agreedDate;
  final DateTime withdrawDate;
  final String number;
  final double value;

  Check({
    this.id,
    this.clientId,
    this.name,
    this.paymentId,
    this.expectedDate,
    this.effectiveDate,
    this.agreedDate,
    this.withdrawDate,
    this.number,
    this.value,
  });
}
