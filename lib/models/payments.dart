class Payment {
  final int id;
  final int clientId;
  final String name;
  final DateTime expectedDate;
  final DateTime effectiveDate;
  final double amount;

  Payment({
    this.id,
    this.clientId,
    this.name,
    this.expectedDate,
    this.effectiveDate,
    this.amount,
  });
}
