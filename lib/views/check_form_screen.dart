import '../models/payments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/checks.dart';
import '../models/checks.dart';
import '../widgets/date_input.dart';

class CheckFormScreen extends StatefulWidget {
  @override
  _CheckFormScreenState createState() => _CheckFormScreenState();
}

class _CheckFormScreenState extends State<CheckFormScreen> {
  Payment _payment;
  final _agreedDateFocusNode = FocusNode();
  final _numberFocusNode = FocusNode();
  final _valueFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;
  TextEditingController _agreedDateController = new TextEditingController();

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
    _agreedDateFocusNode.dispose();
    _numberFocusNode.dispose();
    _valueFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();

    final sValue = (_formData['value'] as String).replaceAll(",", ".");
    final check = Check(
      clientId: _payment.clientId,
      name: _payment.name,
      paymentId: _payment.id,
      expectedDate: _payment.expectedDate,
      effectiveDate: _payment.effectiveDate,
      agreedDate: DateFormat("dd/MM/yyyy").parse(_formData['agreedDate']),
      number: _formData['number'],
      value: double.parse(sValue),
    );

    setState(() {
      _isLoading = true;
    });

    final checks = Provider.of<Checks>(context, listen: false);
    try {
      await checks.addCheck(check);
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro [' + error.toString() + ']'),
          content: Text('Erro ao salvar um cheque'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    _payment = ModalRoute.of(context).settings.arguments as Payment;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cheques'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                      _payment.name,
                      style: TextStyle(fontSize: 18),
                    ),
                    Divider(),
                    Text(
                      'Data prevista do pagamento',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(_payment.expectedDate),
                      style: TextStyle(fontSize: 18),
                    ),
                    Divider(),
                    Text(
                      'Data efetiva do pagamento',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(_payment.effectiveDate),
                      style: TextStyle(fontSize: 18),
                    ),
                    Divider(),
                    Text(
                      'Valor',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      NumberFormat('##,##0.00', 'pt_BR')
                          .format(_payment.amount),
                      style: TextStyle(fontSize: 18),
                    ),
                    Divider(),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Data Prevista de Desconto',
                        hintText: 'Selecione uma data',
                        prefixIcon: InkWell(
                          onTap: () {
                            _selectDate(context, _agreedDateController);
                          },
                          child: Icon(Icons.calendar_today),
                        ),
                      ),
                      controller: _agreedDateController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [DateTextFormatter()],
                      textInputAction: TextInputAction.next,
                      focusNode: _agreedDateFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_numberFocusNode);
                      },
                      onSaved: (value) {
                        _formData['agreedDate'] = value;
                      },
                      validator: (value) {
                        if (!dateStringValid(value)) {
                          return 'Data não válida';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['number'],
                      decoration: InputDecoration(labelText: 'Número'),
                      textInputAction: TextInputAction.next,
                      focusNode: _numberFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_valueFocusNode);
                      },
                      onSaved: (value) => _formData['number'] = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Valor',
                        hintText: 'Entre o valor',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      focusNode: _valueFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_agreedDateFocusNode);
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
