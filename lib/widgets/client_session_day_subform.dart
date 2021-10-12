import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/enums/hour_day.dart';
import '../models/enums/week_day.dart';
import '../models/session_days.dart';
import '../providers/session_days.dart';

class ClientSessionDaySubform extends StatefulWidget {
  final _clientId;

  ClientSessionDaySubform(this._clientId);

  @override
  _ClientSessionDaySubformState createState() =>
      _ClientSessionDaySubformState();
}

class _ClientSessionDaySubformState extends State<ClientSessionDaySubform> {
  bool _showAddSessionDay = false;
  var _selectedSessionDay;
  var _selectedSessionHour;
  var _sessionDaysProvider;
  List<SessionDay> _wSessionDays;

  @override
  void initState() {
    super.initState();
    _wSessionDays = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sessionDaysProvider = Provider.of<SessionDays>(context);
    _wSessionDays = _sessionDaysProvider.items
        .where((item) => item.clientId == widget._clientId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showAddSessionDay = !_showAddSessionDay;
                      });
                    },
                    child: Icon(!_showAddSessionDay
                        ? Icons.expand_more
                        : Icons.expand_less),
                  ),
                  Text(
                    '  Dias de sessão',
                    style: TextStyle(
                      fontSize:
                          _wSessionDays != null && _wSessionDays.length != 0
                              ? 12
                              : 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              if (_showAddSessionDay)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<WeekDay>(
                      menuMaxHeight: 300,
                      value: _selectedSessionDay,
                      items: WeekDayList,
                      hint: Text('Dia da Semana'),
                      onChanged: (value) {
                        setState(() {
                          _selectedSessionDay = value;
                        });
                      },
                    ),
                    DropdownButton<HourDay>(
                      menuMaxHeight: MediaQuery.of(context).size.height - 100,
                      isDense: true,
                      value: _selectedSessionHour,
                      items: HourDayList,
                      hint: Text('Hora do Dia'),
                      onChanged: (value) {
                        setState(() {
                          _selectedSessionHour = value;
                        });
                      },
                    ),
                    InkWell(
                      onTap: () {
                        if (_selectedSessionDay != null &&
                            _selectedSessionHour != null) {
                          final newSessionDay = SessionDay(
                            id: Random().nextInt(5),
                            clientId: widget._clientId,
                            day: _selectedSessionDay,
                            hour: _selectedSessionHour,
                          );
                          _sessionDaysProvider.addSessionDay(newSessionDay);
                          setState(() {
                            _wSessionDays.add(newSessionDay);
                            _wSessionDays.sort(
                                (a, b) => a.day.index.compareTo(b.day.index));
                            _showAddSessionDay = false;
                          });
                        }
                      },
                      child: Icon(Icons.add_circle),
                    ),
                  ],
                )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Column(
            children: _wSessionDays.asMap().entries.map<Widget>((item) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    ' ${item.key + 1} - ${item.value.dayText}  à(s) ${item.value.hour.toString().substring(item.value.hour.toString().indexOf("h") + 1).replaceAll("m", ":")} hora(s)',
                    style: TextStyle(fontSize: 16, color: Colors.grey[900]),
                  ),
                  Expanded(child: Divider(height: 20)),
                  InkWell(
                    onTap: () {
                      _sessionDaysProvider.deleteSessionDay(item.value.id);
                      setState(() {
                        _wSessionDays.remove(item.value);
                      });
                    },
                    child: Icon(Icons.delete),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
