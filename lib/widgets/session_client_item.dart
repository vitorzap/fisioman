import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/sessions.dart';
import '../providers/sessions.dart';
import '../models/enums/payment_status.dart';
import '../utils/constants.dart';

class ClientSessionItem extends StatelessWidget {
  final Session _session;

  ClientSessionItem(this._session);

  void handleMenuChoice(BuildContext context, String value, Session session) {
    var dialogTitle = '';
    var dialogContent = '';
    var noOptions = 2;
    var dialogPaidState = PaymentStatus.NotPaid;

    switch (value) {
      case Constants.DELETE:
        if (session.paymentId != null && session.paymentId > 0) {
          dialogTitle = 'Exclusão cancelada';
          dialogContent =
              'Sessão incluida em pagamento não pode ser excluída ! Exclua o pagamento para efetuar esta ação';
          noOptions = 1;
          dialogPaidState = null;
        } else {
          dialogTitle = 'Confirme a exclusão';
          dialogContent = 'Excluir o sessão ?';
          dialogPaidState = null;
        }
        break;
      case Constants.SCHEDULE:
        dialogTitle = 'Programar pagamento';
        dialogContent = 'Confirmar ?';
        dialogPaidState = PaymentStatus.ToSchedule;
        break;
      case Constants.NOSCHEDULE:
        dialogTitle = 'Cancelar programar';
        dialogContent = 'Confirmar ?';
        dialogPaidState = PaymentStatus.NotPaid;
        break;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(dialogTitle),
        content: Text(dialogContent),
        actions: [
          TextButton(
            child: noOptions != 1 ? Text('Sim') : Text('Ok'),
            onPressed: () =>
                Navigator.of(ctx).pop(noOptions != 1 ? true : false),
          ),
          if (noOptions > 1)
            TextButton(
              child: Text('Não'),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
        ],
      ),
    ).then(
      (value) async {
        if (value) {
          if (dialogPaidState == null) {
            Provider.of<Sessions>(context, listen: false)
                .deleteSession(_session.id);
          } else {
            Provider.of<Sessions>(context, listen: false)
                .updateStatus(_session.id, _session.effected, dialogPaidState);
          }
        }
      },
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(DateFormat('dd/MM/yy hh:mm').format(_session.dateTime),
          style: TextStyle(fontSize: 18)),
      title: _session.effected ? Text('Efetivada') : Text('Prevista'),
      subtitle: _session.effected
          ? Text(paymentStatusToText(_session.paid),
              style: TextStyle(fontSize: 14))
          : Text(''),
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
            PopupMenuButton<String>(
              onSelected: (choice) =>
                  handleMenuChoice(context, choice, _session),
              itemBuilder: (BuildContext context) {
                return (!_session.effected &&
                            _session.paid != PaymentStatus.Scheduled &&
                            _session.paid != PaymentStatus.Paid
                        ? Constants.SESSION_SCREEN_OPTIONS_FORESEEN
                        : _session.paid == PaymentStatus.NotPaid
                            ? Constants.SESSION_SCREEN_OPTIONS_NOTPAID
                            : Constants.SESSION_SCREEN_OPTIONS_TOSCHEDULE)
                    .map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
      ),
    );
  }
}
