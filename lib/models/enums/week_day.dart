import 'package:flutter/material.dart';

enum WeekDay { Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday }

final WeekDayList = [
  DropdownMenuItem<WeekDay>(value: WeekDay.Sunday, child: Text('Domingo')),
  DropdownMenuItem<WeekDay>(value: WeekDay.Monday, child: Text('Segunda')),
  DropdownMenuItem<WeekDay>(value: WeekDay.Tuesday, child: Text('Terça')),
  DropdownMenuItem<WeekDay>(value: WeekDay.Wednesday, child: Text('Quarta')),
  DropdownMenuItem<WeekDay>(value: WeekDay.Thursday, child: Text('Quinta')),
  DropdownMenuItem<WeekDay>(value: WeekDay.Friday, child: Text('Sexta')),
  DropdownMenuItem<WeekDay>(value: WeekDay.Saturday, child: Text('Sabado')),
];
