import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/enums/hour_day.dart';
import '../models/clients.dart';
import '../widgets/date_input.dart';
import '../providers/sessions.dart';
import '../models/sessions.dart';
import '../models/enums/payment_status.dart';

class SessionFormScreen extends StatefulWidget {
  @override
  _SessionFormScreenState createState() => _SessionFormScreenState();
}

class _SessionFormScreenState extends State<SessionFormScreen> {
  Client _client;
  final _sessionDateFocusNode = FocusNode();
  final _sessionHourFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  TextEditingController _expectedDateController = new TextEditingController();
  var _selectedSessionHour;

  _selectDate(BuildContext context, TextEditingController controller) async {
    var _pickedDate = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (_pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(_pickedDate);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _sessionDateFocusNode.dispose();
    _sessionHourFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();

    var sDateTime = _formData['sessionDate'].toString() +
        ' ' +
        formatedHour(_formData['sessionHour'].toString());

    final session = Session(
      clientId: _client.id,
      name: _client.name,
      dateTime: DateFormat("dd/MM/yyyy hh:mm").parse(sDateTime),
      effected: false,
      paid: PaymentStatus.NotPaid,
    );

    final sessions = Provider.of<Sessions>(context, listen: false);
    try {
      await sessions.addSession(session);
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro [' + error.toString() + ']'),
          content: Text('Erro ao salvar uma sessão'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    _client = ModalRoute.of(context).settings.arguments as Client;
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Sessão'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'Nome',
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).primaryColor),
              ),
              Text(
                _client.name,
                style: TextStyle(fontSize: 18),
              ),
              Divider(),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Data Prevista da Sessão',
                  hintText: 'Selecione uma data',
                  prefixIcon: InkWell(
                    onTap: () {
                      _selectDate(context, _expectedDateController);
                    },
                    child: Icon(Icons.calendar_today),
                  ),
                ),
                controller: _expectedDateController,
                keyboardType: TextInputType.number,
                inputFormatters: [DateTextFormatter()],
                textInputAction: TextInputAction.next,
                focusNode: _sessionDateFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_sessionHourFocusNode);
                },
                onSaved: (value) {
                  _formData['sessionDate'] = value;
                },
                validator: (value) {
                  if (!dateStringValid(value)) {
                    return 'Data não válida';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<HourDay>(
                decoration: InputDecoration(
                  labelText: 'Hora Prevista da Sessão',
                  hintText: 'Selecione um horário',
                  prefixIcon: Icon(Icons.schedule),
                ),
                value: _selectedSessionHour,
                items: HourDayList,
                focusNode: _sessionHourFocusNode,
                onSaved: (value) => _formData['sessionHour'] = value,
                onChanged: (value) {
                  setState(() {
                    _selectedSessionHour = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Informe uma hora do dia !';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
