import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/clients.dart';
import '../providers/payments.dart';
import '../utils/app_routes.dart';
import '../widgets/date_input.dart';
import '../models/payments.dart';
import '../models/enums/payment_frequency.dart';

class PaymentConfirmFormArguments {
  final Payment payment;
  final String predecessor;

  PaymentConfirmFormArguments(this.payment, this.predecessor);
}

class PaymentConfirmFormScreen extends StatefulWidget {
  @override
  _PaymentConfirmFormScreenState createState() =>
      _PaymentConfirmFormScreenState();
}

class _PaymentConfirmFormScreenState extends State<PaymentConfirmFormScreen> {
  Payment _payment;
  String _predecessor;
  final _effectiveDateFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;
  TextEditingController _effectiveDateController = new TextEditingController();
  var _generateNewPayment = true;

  bool isNumericDouble(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  _selectDate(BuildContext context, TextEditingController controller) async {
    var _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1919),
      lastDate: DateTime.now(),
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
    _effectiveDateFocusNode.dispose();
  }

  bool _dateValid(String date) {
    if (date.trim().isEmpty) {
      return false;
    }
    if (!dateStringValid(date)) {
      return false;
    }
    try {
      DateTime dtx = DateFormat('dd/MM/yyyy').parse(date);
      if (DateTime.now().isBefore(dtx)) {
        return false;
      }
    } catch (error) {
      return false;
    }

    return true;
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    final payments = Provider.of<Payments>(context, listen: false);
    if (_predecessor == AppRoutes.CLIENT_PAYMENT_SCREEN) {
      payments.updateDateEffective(_payment.id,
          _payment.effectiveDate == null ? _formData['effectiveDate'] : null);
    } else {
      payments.updateDateEffectiveAndExcludeFromList(
          _payment.id, _formData['effectiveDate']);
    }

    if (_generateNewPayment) {
      final clients = Provider.of<Clients>(context, listen: false);
      final index =
          clients.items.indexWhere((item) => item.id == _payment.clientId);
      if (index >= 0) {
        final paymentFrequency = clients.items[index].paymentFrequency;
        if (paymentFrequency != PaymentFrequency.Eventual) {
          var wDay = _payment.expectedDate.day;
          var wMonth = _payment.expectedDate.month;
          var wYear = _payment.expectedDate.year;
          if (paymentFrequency == PaymentFrequency.Mensal) {
            wMonth = wMonth + 1;
          } else {
            wMonth = wMonth + 3;
          }
          if (wMonth > 12) {
            wYear = wYear + 1;
            wMonth = wMonth - 12;
          }
          if (wDay == 31 &&
              (wMonth == 4 || wMonth == 6 || wMonth == 9 || wMonth == 11)) {
            wDay = 30;
          }
          if (wDay > 28 && wMonth == 2) {
            wDay = 28;
          }
          var sDate = wDay.toString() +
              '/' +
              wMonth.toString() +
              '/' +
              wYear.toString();
          var newDate = DateFormat('dd/MM/yyy').parse(sDate);
          Payment newPayment = Payment(
            id: _payment.id,
            clientId: _payment.clientId,
            name: _payment.name,
            expectedDate: newDate,
            effectiveDate: null,
            amount: _payment.amount,
          );
          await payments.addPayment(newPayment);
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context).settings.arguments
        as PaymentConfirmFormArguments;
    _payment = argument.payment;
    _predecessor = argument.predecessor;
    _effectiveDateController.text =
        DateFormat('dd/MM/yyyy').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmar pagamento'),
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
                      'Data prevista de pagamento',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(_payment.expectedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                    Divider(),
                    Text(
                      'Valor',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      NumberFormat("##,##0.00", "pt_BR")
                          .format(_payment.amount),
                      style: TextStyle(fontSize: 16),
                    ),
                    Divider(),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Data Efetiva de Pagamento',
                        hintText: 'Selecione uma data',
                        prefixIcon: InkWell(
                          onTap: () {
                            _selectDate(context, _effectiveDateController);
                          },
                          child: Icon(Icons.calendar_today),
                        ),
                      ),
                      controller: _effectiveDateController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [DateTextFormatter()],
                      textInputAction: TextInputAction.next,
                      focusNode: _effectiveDateFocusNode,
                      onSaved: (value) {
                        _formData['effectiveDate'] = value;
                      },
                      validator: (value) {
                        if (!_dateValid(value)) {
                          return 'Data não válida';
                        }
                        return null;
                      },
                    ),
                    Divider(),
                    CheckboxListTile(
                      title: Text("Gerar novo item de pagamento"),
                      value: _generateNewPayment,
                      onChanged: (newValue) {
                        setState(() {
                          _generateNewPayment = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading, //
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
