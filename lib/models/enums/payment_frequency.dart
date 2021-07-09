import 'package:flutter/material.dart';

enum PaymentFrequency { Mensal, Trimestral, Eventual }

final PaymentFrequencyList = [
  DropdownMenuItem<PaymentFrequency>(
      value: PaymentFrequency.Mensal, child: Text('Mensal')),
  DropdownMenuItem<PaymentFrequency>(
      value: PaymentFrequency.Trimestral, child: Text('Trimestral')),
  DropdownMenuItem<PaymentFrequency>(
      value: PaymentFrequency.Eventual, child: Text('Eventual'))
];
