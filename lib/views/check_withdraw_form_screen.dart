import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/checks.dart';
import '../models/checks.dart';
import '../utils/app_routes.dart';
import '../widgets/date_input.dart';

class CheckWithdrawFormArguments {
  final Check check;
  final String predecessor;

  CheckWithdrawFormArguments(this.check, this.predecessor);
}

class CheckWithdrawFormScreen extends StatefulWidget {
  @override
  _CheckWithdrawFormScreenState createState() =>
      _CheckWithdrawFormScreenState();
}

class _CheckWithdrawFormScreenState extends State<CheckWithdrawFormScreen> {
  Check _check;
  String _predecessor;
  final _withdrawDateFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;
  TextEditingController _withdrawDateController = new TextEditingController();

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
    _withdrawDateFocusNode.dispose();
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

    final checks = Provider.of<Checks>(context, listen: false);
    if (_predecessor == AppRoutes.PAYMENT_CHECK_SCREEN) {
      checks.updateWithdrawDate(_check.id,
          _check.withdrawDate == null ? _formData['withdrawDate'] : null);
    } else {
      checks.updateWithdrawDateAndExcludeFromList(
          _check.id, _formData['withdrawDate']);
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context).settings.arguments as CheckWithdrawFormArguments;
    _check = argument.check;
    _predecessor = argument.predecessor;
    _withdrawDateController.text =
        DateFormat('dd/MM/yyyy').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmar cheque descontado'),
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
                      _check.name,
                      style: TextStyle(fontSize: 18),
                    ),
                    Divider(),
                    Text(
                      'Número do cheque',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      _check.number,
                      style: TextStyle(fontSize: 18),
                    ),
                    Divider(),
                    Text(
                      'Data prevista de desconto',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(_check.agreedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                    Divider(),
                    Text(
                      'Valor',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      NumberFormat("##,##0.00", "pt_BR").format(_check.value),
                      style: TextStyle(fontSize: 16),
                    ),
                    Divider(),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Data de desconto do cheque',
                        hintText: 'Selecione uma data',
                        prefixIcon: InkWell(
                          onTap: () {
                            _selectDate(context, _withdrawDateController);
                          },
                          child: Icon(Icons.calendar_today),
                        ),
                      ),
                      controller: _withdrawDateController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [DateTextFormatter()],
                      textInputAction: TextInputAction.next,
                      focusNode: _withdrawDateFocusNode,
                      onSaved: (value) {
                        _formData['withdrawDate'] = value;
                      },
                      validator: (value) {
                        if (!_dateValid(value)) {
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
