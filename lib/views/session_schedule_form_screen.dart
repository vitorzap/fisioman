import 'package:fisioman/models/payments.dart';
import 'package:fisioman/providers/payments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/clients.dart';
import '../widgets/date_input.dart';
import '../providers/sessions.dart';

class SessionScheduleArguments {
  final Client client;
  final List<String> sessionsDates;

  SessionScheduleArguments(this.client, this.sessionsDates);
}

class SessionScheduleFormScreen extends StatefulWidget {
  @override
  _SessionScheduleFormScreenState createState() =>
      _SessionScheduleFormScreenState();
}

class _SessionScheduleFormScreenState extends State<SessionScheduleFormScreen> {
  SessionScheduleArguments _sessionScheduleArguments;
  Client _client;
  List<String> _sessionsDates;
  final _payDateFocusNode = FocusNode();
  final _valueFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  TextEditingController _expectedDateController = new TextEditingController();

  bool isNumericDouble(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

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
    _payDateFocusNode.dispose();
    _valueFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();

    final sValue = (_formData['value'] as String).replaceAll(",", ".");
    final payment = Payment(
      clientId: _client.id,
      name: _client.name,
      expectedDate: DateFormat("dd/MM/yyyy").parse(_formData['expectedDate']),
      amount: double.parse(sValue),
    );

    final payments = Provider.of<Payments>(context, listen: false);
    try {
      final payId = await payments.addPaymentFromSessions(payment);
      final sessions = Provider.of<Sessions>(context, listen: false);
      await sessions.updatePaymentId(payId);
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro [' + error.toString() + ']'),
          content: Text('Erro ao salvar um pagamento (de sessões)'),
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
    _sessionScheduleArguments =
        ModalRoute.of(context).settings.arguments as SessionScheduleArguments;
    _client = _sessionScheduleArguments.client;
    _sessionsDates = _sessionScheduleArguments.sessionsDates;

    return Scaffold(
      appBar: AppBar(
        title: Text('Programar pagamento'),
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
              Text(
                _sessionsDates.length == 1
                    ? 'Sessão'
                    : 'Sessões (' + _sessionsDates.length.toString() + ')',
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).primaryColor),
              ),
              GridView.count(
                primary: false,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                childAspectRatio: 6,
                children: _sessionsDates.map<Widget>((sessioDate) {
                  return Container(
                      alignment: Alignment.center,
                      color: Colors.grey[200],
                      height: 20,
                      child: Text(
                        sessioDate,
                        style: TextStyle(fontSize: 16, color: Colors.grey[900]),
                      ));
                }).toList(),
              ),
              Divider(),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Data Prevista de Pagamento',
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
                focusNode: _payDateFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_valueFocusNode);
                },
                onSaved: (value) {
                  _formData['expectedDate'] = value;
                },
                validator: (value) {
                  if (!dateStringValid(value)) {
                    return 'Data não válida';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Valor',
                  hintText: 'Entre o valor',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                focusNode: _valueFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_payDateFocusNode);
                },
                onSaved: (value) => _formData['value'] = value,
                validator: (value) {
                  if (isNumericDouble(value)) {
                    return 'Valor inválido';
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
