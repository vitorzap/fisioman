import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/sessions.dart';
import '../providers/sessions.dart';
import '../models/enums/payment_status.dart';

class SessionItem extends StatelessWidget {
  final Session _session;

  SessionItem(this._session);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(DateFormat('hh:mm').format(_session.dateTime),
          style: TextStyle(fontSize: 18)),
      title: Text(_session.name),
      subtitle: _session.effected
          ? Text(paymentStatusToText(_session.paid),
              style: TextStyle(fontSize: 14))
          : Text('Prevista'),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                _session.effected ? Icons.cancel : Icons.check_box,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                if (_session.paymentId == null || _session.paymentId == 0) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: !_session.effected
                          ? Text('Informar Execução')
                          : Text('Cancelar Execução'),
                      content: !_session.effected
                          ? Text('Confirma a Execução ?')
                          : Text('Confirmar o cancelamento ?'),
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
                        Provider.of<Sessions>(context, listen: false)
                            .updateStatus(
                                _session.id, !_session.effected, _session.paid);
                      }
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Sessão incluida em pagamento não pode ter sua execução cancelada'),
                    duration: Duration(seconds: 1),
                  ));
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                if (_session.paymentId == null || _session.paymentId == 0) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Confirme a exclusão'),
                      content: Text('Excluir o sessão ?'),
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
                        Provider.of<Sessions>(context, listen: false)
                            .deleteSession(_session.id);
                      }
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Sessão incluida em pagamento não pode ser excluída'),
                    duration: Duration(seconds: 1),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
