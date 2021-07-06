import '../providers/checks.dart';

final DUMMY_CHECKS = [
  Check(
      id: 1,
      clientId: 1,
      name: 'Joao',
      paymentId: 1,
      expectedDate: DateTime.parse('2021-05-02 00:00:00'),
      effectiveDate: DateTime.parse('2021-05-02 00:00:00'),
      agreedDate: DateTime.parse('2021-05-02 00:00:00'),
      withdrawDate: null,
      number: '23456',
      value: 250.00),
  Check(
      id: 2,
      clientId: 1,
      name: 'Joao',
      paymentId: 2,
      expectedDate: DateTime.parse('2021-06-02 00:00:00'),
      effectiveDate: DateTime.parse('2021-06-02 00:00:00'),
      agreedDate: DateTime.parse('2021-06-02 00:00:00'),
      withdrawDate: null,
      number: '23457',
      value: 250.00),
];
