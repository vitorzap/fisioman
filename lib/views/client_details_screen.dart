import 'package:fisioman/providers/session_days.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/clients.dart';

class ClientDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final client = ModalRoute.of(context).settings.arguments as Client;
    final sessionDays = Provider.of<SessionDays>(context);
    final sessionDaysClientItems =
        sessionDays.items.where((item) => item.clientId == client.id).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do cliente'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            Container(
              height: 150,
              width: 111,
              child: client.photoFile == null
                  ? Container(
                      child: Center(child: Text('Foto')),
                      decoration: BoxDecoration(border: Border.all()),
                    )
                  : Image.file(
                      client.photoFile,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
            ListTile(
              title: Text('Nome'),
              subtitle: Text(client.name),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text(client.email),
            ),
            ListTile(
              title: Text('Telefone'),
              subtitle: Text(client.telephone),
            ),
            ListTile(
              title: Text('Endereço'),
              subtitle: Text(client.address),
            ),
            ListTile(
              title: Text('Data Nascimento'),
              subtitle: Text(client.birthDate == null
                  ? ''
                  : DateFormat('dd/MM/yyyy').format(client.birthDate)),
            ),
            ListTile(
              title: Text('Data de Início'),
              subtitle: Text(client.startDate == null
                  ? ''
                  : DateFormat('dd/MM/yyyy').format(client.startDate)),
            ),
            ListTile(
              title: Text('Frequência de pagamento'),
              subtitle: client.paymentFrequency == null
                  ? Text('')
                  : Text(client.paymentFrequency.toString().substring(
                      client.paymentFrequency.toString().indexOf(".") + 1)),
            ),
            Container(
              // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              height: 45.0 + sessionDaysClientItems.length * 25.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Text(
                      'Dias de sessão:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[850],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 4, 12, 8),
                    child: Column(
                      children:
                          sessionDaysClientItems.asMap().entries.map((item) {
                        return Row(
                          children: [
                            Text(
                              ' ${item.key + 1} - ${item.value.dayText}  à(s) ${item.value.hour.toString().substring(item.value.hour.toString().indexOf("h") + 1).replaceAll("m", ":")} hora(s)',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700]),
                            ),
                            Divider(height: 20),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('ID'),
              subtitle: Text(client.id.toString()),
            ),
          ]),
        ),
      ),
    );
  }
}
