import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/clients.dart';
import '../widgets/date_input.dart';
import '../providers/payments.dart';
import '../models/payments.dart';

class PaymentFormScreen extends StatefulWidget {
  @override
  _PaymentFormScreenState createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  Client _client;
  final _expectedDateFocusNode = FocusNode();
  final _valueFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;
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
    _expectedDateFocusNode.dispose();
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

    setState(() {
      _isLoading = true;
    });

    final payments = Provider.of<Payments>(context, listen: false);
    try {
      await payments.addPayment(payment);
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro [' + error.toString() + ']'),
          content: Text('Erro ao salvar um pagamento'),
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
    _client = ModalRoute.of(context).settings.arguments as Client;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagamento previsto'),
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
                      _client.name,
                      style: TextStyle(fontSize: 18),
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
                      focusNode: _expectedDateFocusNode,
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
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      focusNode: _valueFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_expectedDateFocusNode);
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
