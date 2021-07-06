import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/payments.dart';
import '../widgets/payment_client_item.dart';
import '../utils/app_routes.dart';
import '../providers/checks.dart';
import '../widgets/check_payment_item.dart';

class PaymentCheckScreen extends StatefulWidget {
  @override
  _PaymentCheckScreenState createState() => _PaymentCheckScreenState();
}

class _PaymentCheckScreenState extends State<PaymentCheckScreen> {
  bool _isLoading = false;
  Payment _payment;

  _getChecks(Payment payment) async {
    Provider.of<Checks>(context, listen: false)
        .loadChecksByPayment(payment.id)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        _payment = ModalRoute.of(context).settings.arguments as Payment;
      });
      _getChecks(_payment);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentChecks = Provider.of<Checks>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cheques do Pagamento'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.CHECK_FORM_SCREEN,
                arguments: _payment,
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                          color: Colors.grey[300],
                          width: 1,
                          style: BorderStyle.solid),
                    )),
                    child: ListTile(
                        title: _payment == null
                            ? Text('')
                            : Text(_payment.name,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                        subtitle: _payment == null
                            ? Text('')
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Previsto: ${DateFormat('dd/MM/yyyy').format(_payment.expectedDate)}"),
                                      Text(
                                          "Efetuado: ${DateFormat('dd/MM/yyyy').format(_payment.effectiveDate)}"),
                                    ],
                                  ),
                                  Divider(),
                                  Text(
                                      "Valor: ${NumberFormat('##,##0.00', 'pt_BR').format(_payment.amount)}"),
                                ],
                              )),
                  ),
                  paymentChecks.itemsCount == 0
                      ? Expanded(
                          child: Center(
                            child: Text("Nenhum cheque cadastrado"),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: paymentChecks.itemsCount,
                            itemBuilder: (ctx, index) => Column(
                              children: <Widget>[
                                CheckPaymentItem(paymentChecks.items[index]),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
