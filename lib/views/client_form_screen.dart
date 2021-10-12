import 'dart:io';

import 'package:fisioman/widgets/client_session_day_subform.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/clients.dart';
import '../providers/clients.dart';
import '../models/enums/payment_frequency.dart';
import '../widgets/date_input.dart';
import '../widgets/image_input.dart';

class ClientFormScreen extends StatefulWidget {
  @override
  _ClientFormScreenState createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _telephoneFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _birthDateFocusNode = FocusNode();
  final _startDateFocusNode = FocusNode();
  final _paymentFrequencyFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;
  TextEditingController _birthDateController = new TextEditingController();
  TextEditingController _startDateController = new TextEditingController();
  File _pickedImage;

  var _selectedPaymentFrequency;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  bool isNumericInteger(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  _selectDate(BuildContext context, TextEditingController controller) async {
    var _pickedDate = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final client = ModalRoute.of(context).settings.arguments as Client;
      if (client != null) {
        _formData['id'] = client.id;
        _formData['name'] = client.name;
        _formData['email'] = client.email;
        _formData['telephone'] = client.telephone;
        _formData['address'] = client.address;
        _formData['photoFile'] = client.photoFile;
        _birthDateController.text = client.birthDate == null
            ? null
            : DateFormat('dd/MM/yyyy').format(client.birthDate);
        _startDateController.text = client.startDate == null
            ? null
            : DateFormat('dd/MM/yyyy').format(client.startDate);
        _formData['paymentFrequency'] = client.paymentFrequency;
        _selectedPaymentFrequency = client.paymentFrequency;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _telephoneFocusNode.dispose();
    _addressFocusNode.dispose();
    _birthDateFocusNode.dispose();
    _startDateFocusNode.dispose();
    _paymentFrequencyFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }
    _form.currentState.save();

    final client = Client(
      id: _formData['id'],
      name: _formData['name'],
      email: _formData['email'],
      telephone: _formData['telephone'],
      address: _formData['address'],
      birthDate: _formData['birthDate'] == null || _formData['birthDate'] == ''
          ? null
          : DateFormat("dd/MM/yyyy").parse(_formData['birthDate']),
      startDate: _formData['startDate'] == null || _formData['startDate'] == ''
          ? null
          : DateFormat("dd/MM/yyyy").parse(_formData['startDate']),
      photoFile: _pickedImage != null ? _pickedImage : _formData['photoFile'],
      paymentFrequency: _formData['paymentFrequency'],
    );

    setState(() {
      _isLoading = true;
    });

    final clients = Provider.of<Clients>(context, listen: false);
    try {
      if (_formData['id'] == null) {
        await clients.addClient(client);
      } else {
        await clients.updateClient(client);
      }
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro [' + error.toString() + ']'),
          content: Text('Erro ao salvar um cliente'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Clientes'),
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
                    ImageInput(_formData['photoFile'], _selectImage),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: _formData['name'],
                      decoration: InputDecoration(labelText: 'Nome'),
                      textInputAction: TextInputAction.next,
                      focusNode: _nameFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                      onSaved: (value) => _formData['name'] = value,
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInValid = value.trim().length < 3;

                        if (isEmpty || isInValid) {
                          return 'Informe um nome válido !';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['email'],
                      decoration: InputDecoration(labelText: 'EMail'),
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_telephoneFocusNode);
                      },
                      onSaved: (value) => _formData['email'] = value,
                      validator: (value) {
                        if (value.trim().isNotEmpty) {
                          if (value.trim().length < 8 || !value.contains('@')) {
                            return 'Informe um email válido !';
                          }
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['telephone'],
                      decoration: InputDecoration(labelText: 'Telefone'),
                      textInputAction: TextInputAction.next,
                      focusNode: _telephoneFocusNode,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_addressFocusNode);
                      },
                      onSaved: (value) => _formData['telephone'] = value,
                      validator: (value) {
                        if (value.trim().isNotEmpty) {
                          if (!isNumericInteger(value)) {
                            return 'Informe um número de telefone válido !';
                          }
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['address'],
                      decoration: InputDecoration(labelText: 'Endereço'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      // textInputAction: TextInputAction.next,
                      focusNode: _addressFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_birthDateFocusNode);
                      },
                      onSaved: (value) => _formData['address'] = value,
                    ),
                    TextFormField(
                      // initialValue: _formData['birthDate'],
                      decoration: InputDecoration(
                        labelText: 'Data de Nascimento',
                        hintText: 'Selecione uma data',
                        prefixIcon: InkWell(
                          onTap: () {
                            _selectDate(context, _birthDateController);
                          },
                          child: Icon(Icons.calendar_today),
                        ),
                      ),
                      controller: _birthDateController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [DateTextFormatter()],
                      textInputAction: TextInputAction.next,
                      focusNode: _birthDateFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_startDateFocusNode);
                      },
                      onSaved: (value) {
                        _formData['birthDate'] = value;
                      },
                      validator: (value) {
                        if (value.trim().isNotEmpty) {
                          if (!dateStringValid(value)) {
                            return 'Data não válida';
                          }
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Data de Início',
                        hintText: 'Selecione uma data',
                        prefixIcon: InkWell(
                          onTap: () {
                            _selectDate(context, _startDateController);
                          },
                          child: Icon(Icons.calendar_today),
                        ),
                      ),
                      controller: _startDateController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      inputFormatters: [DateTextFormatter()],
                      focusNode: _startDateFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_paymentFrequencyFocusNode);
                      },
                      onSaved: (value) => _formData['startDate'] = value,
                      validator: (value) {
                        if (value.trim().isNotEmpty) {
                          if (!dateStringValid(value)) {
                            return 'Data não válida';
                          }
                        }
                        // } else {
                        //   return 'Informe uma Data de Início';
                        // }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_selectedPaymentFrequency != null)
                      Container(
                        child: Text(
                          'Frequencia de Pagamento',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        height: 15,
                      ),
                    DropdownButtonFormField<PaymentFrequency>(
                      value: _selectedPaymentFrequency,
                      items: PaymentFrequencyList,
                      hint: Text('Frequencia de pagamento'),
                      focusNode: _paymentFrequencyFocusNode,
                      onSaved: (value) => _formData['paymentFrequency'] = value,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentFrequency = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Informe uma frequencia de pagamento !';
                        }
                        return null;
                      },
                    ),
                    if (_formData['id'] != null)
                      ClientSessionDaySubform(_formData['id']),
                  ],
                ),
              ),
            ),
    );
  }
}
