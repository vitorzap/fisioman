import 'package:fisioman/models/enums/payment_status.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sessions.dart';
import '../models/clients.dart';
import '../widgets/session_client_item.dart';
import '../utils/app_routes.dart';
import '../views/session_schedule_form_screen.dart';

class ClientSessionScreen extends StatefulWidget {
  @override
  _ClientSessionScreenState createState() => _ClientSessionScreenState();
}

class _ClientSessionScreenState extends State<ClientSessionScreen> {
  // bool _isLoading = true;
  bool _isLoading = false;
  Client _client;

  _getSessions(Client client) async {
    Provider.of<Sessions>(context, listen: false)
        .loadSessionsByClient(client.id)
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
      _getSessions(_client);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientSessions = Provider.of<Sessions>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sessões do Cliente'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.SESSION_FORM_SCREEN,
                arguments: _client,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.payment),
            onPressed: () {
              var sessioDatelist = clientSessions.items
                  .where((session) => session.paid == PaymentStatus.ToSchedule)
                  .map((session) =>
                      DateFormat('dd/MM/yyyy hh:mm').format(session.dateTime))
                  .toList();
              if (sessioDatelist.length == 0) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Nenhuma sessão selecionada'),
                  duration: Duration(seconds: 1),
                ));
              } else {
                sessioDatelist.sort();
                Navigator.of(context).pushNamed(
                  AppRoutes.SESSION_SCHEDULE_FORM_SCREEN,
                  arguments: SessionScheduleArguments(_client, sessioDatelist),
                );
              }
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
                          : _client.startDate == null
                              ? Text('')
                              : Text(
                                  "Data de início: ${DateFormat('dd/MM/yyyy').format(_client.startDate)}"),
                    ),
                  ),
                  clientSessions.itemsCount == 0
                      ? Expanded(
                          child: Center(
                            child: Text("Nenhuma sessão cadastrada"),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: clientSessions.itemsCount,
                            itemBuilder: (ctx, index) => Column(
                              children: <Widget>[
                                ClientSessionItem(clientSessions.items[index]),
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
