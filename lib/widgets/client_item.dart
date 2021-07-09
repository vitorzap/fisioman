import 'package:fisioman/providers/session_days.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/clients.dart';
import '../providers/clients.dart';
import '../utils/app_routes.dart';

class ClientItem extends StatelessWidget {
  final Client client;

  ClientItem(this.client);

  void _clientDetails(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.CLIENT_DETAILS,
      arguments: client,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _clientDetails(context),
      // leading: Text(client.telephone),
      leading: client.photoFile != null
          ? CircleAvatar(backgroundImage: FileImage(client.photoFile))
          : CircleAvatar(),

      title: Text(client.name),
      subtitle: Text(client.telephone),
      // subtitle: Text(client.id.toString()),
      trailing: Container(
        width: 150,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.CLIENT_FORM,
                  arguments: client,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Confirme a exclusão'),
                    content: Text('Excluir o cliente ?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Sim'),
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                      TextButton(
                        child: Text('Não'),
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                    ],
                  ),
                ).then(
                  (value) async {
                    if (value) {
                      Provider.of<Clients>(context, listen: false)
                          .deleteClient(client.id);
                      Provider.of<SessionDays>(context, listen: false)
                          .deleteClientSessionDays(client.id);
                    }
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.monetization_on_sharp),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.CLIENT_PAYMENT_SCREEN,
                  arguments: client,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
