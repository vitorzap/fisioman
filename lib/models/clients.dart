import 'dart:io';
import './enums/payment_frequency.dart';
import 'package:flutter/material.dart';

class Client {
  final int id;
  final String name;
  final String email;
  final String telephone;
  final String address;
  final DateTime birthDate;
  final DateTime startDate;
  final File photoFile;
  final PaymentFrequency paymentFrequency;

  Client({
    this.id,
    this.name,
    this.email,
    this.telephone,
    this.address,
    this.birthDate,
    this.startDate,
    this.photoFile,
    this.paymentFrequency,
  });
}
