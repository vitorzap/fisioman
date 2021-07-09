import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/payments.dart';
import '../models/clients.dart';
import '../providers/clients.dart';
import '../widgets/payment_client_item.dart';
import '../utils/app_routes.dart';

class ClientPaymentScreen extends StatefulWidget {
  @override
  _ClientPaymentScreenState createState() => _ClientPaymentScreenState();
}

class _ClientPaymentScreenState extends State<ClientPaymentScreen> {
  bool _isLoading = false;
  Client _client;

  _getPayments(Client client) async {
    Provider.of<Payments>(context, listen: false)
        .loadPaymentsByClient(client.id)
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
        _client = ModalRoute.of(context).settings.arguments as Client;
      });
      _getPayments(_client);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientPayments = Provider.of<Payments>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagamentos do Cliente'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PAYMENT_FORM_SCREEN,
                arguments: _client,
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
                      title: _client == null
                          ? Text('')
                          : Text(_client.name,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                      subtitle: _client == null
                          ? Text('')
                          : Text(
                              "Data de início: ${DateFormat('dd/MM/yyyy').format(_client.startDate)}"),
                    ),
                  ),
                  clientPayments.itemsCount == 0
                      ? Expanded(
                          child: Center(
                            child: Text("Nenhum pagamento cadastrado"),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: clientPayments.itemsCount,
                            itemBuilder: (ctx, index) => Column(
                              children: <Widget>[
                                ClientPaymentItem(clientPayments.items[index]),
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
