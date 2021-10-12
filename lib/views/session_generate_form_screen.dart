import 'package:fisioman/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/date_input.dart';
import '../providers/sessions.dart';

class SessionGenerateFormScreen extends StatefulWidget {
  @override
  _SessionGenerateFormScreenState createState() =>
      _SessionGenerateFormScreenState();
}

class _SessionGenerateFormScreenState extends State<SessionGenerateFormScreen> {
  final _dateIFocusNode = FocusNode();
  final _dateFFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  TextEditingController _fromDateController = new TextEditingController();
  TextEditingController _untilDateController = new TextEditingController();

  _selectDate(BuildContext context, TextEditingController controller) async {
    var _pickedDate = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 730)),
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
    _dateIFocusNode.dispose();
    _dateFFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();

    final fromDate = DateFormat("dd/MM/yyyy").parse(_formData['fromDate']);
    final untilDate = DateFormat("dd/MM/yyyy").parse(_formData['untilDate']);

    final sessions = Provider.of<Sessions>(context, listen: false);
    try {
      var wGen = await sessions.generateSessions(fromDate, untilDate);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$wGen sessões geradas'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro [' + error.toString() + ']'),
          content: Text('Erro ao gerar sessões)'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerar sessões por dia'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'Gerar sessões por dia a partir de sessões fixas no intervalo informado abaixo',
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).primaryColor),
              ),
              Divider(),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Data inicial',
                  hintText: 'Selecione uma data',
                  prefixIcon: InkWell(
                    onTap: () {
                      _selectDate(context, _fromDateController);
                    },
                    child: Icon(Icons.calendar_today),
                  ),
                ),
                controller: _fromDateController,
                keyboardType: TextInputType.number,
                inputFormatters: [DateTextFormatter()],
                textInputAction: TextInputAction.next,
                focusNode: _dateIFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_dateFFocusNode);
                },
                onSaved: (value) {
                  _formData['fromDate'] = value;
                },
                validator: (value) {
                  if (!dateStringValid(value)) {
                    return 'Data não válida';
                  }
                  final wDate = DateFormat("dd/MM/yyyy").parse(value);
                  final today = DateTime.parse(
                      DateTime.now().toIso8601String().substring(0, 10));
                  if (wDate.isBefore(today)) {
                    return 'Data não deve ser anterior a hoje';
                  }
                  return null;
                },
              ),
              Divider(),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Data final',
                  hintText: 'Selecione uma data',
                  prefixIcon: InkWell(
                    onTap: () {
                      _selectDate(context, _untilDateController);
                    },
                    child: Icon(Icons.calendar_today),
                  ),
                ),
                controller: _untilDateController,
                keyboardType: TextInputType.number,
                inputFormatters: [DateTextFormatter()],
                textInputAction: TextInputAction.next,
                focusNode: _dateFFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_dateIFocusNode);
                },
                onSaved: (value) {
                  _formData['untilDate'] = value;
                },
                validator: (value) {
                  if (!dateStringValid(value)) {
                    return 'Data não válida';
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
