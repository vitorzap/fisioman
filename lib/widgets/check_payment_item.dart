import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/checks.dart';
import '../views/check_withdraw_form_screen.dart';
import '../models/checks.dart';
import '../utils/app_routes.dart';

class CheckPaymentItem extends StatelessWidget {
  final Check _check;

  CheckPaymentItem(this._check);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _check.agreedDate == null &&
              _check.agreedDate.isBefore(DateTime.now())
          ? Text(
              DateFormat('dd/MM/yyyy').format(_check.agreedDate),
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).errorColor),
            )
          : Text(DateFormat('dd/MM/yyyy').format(_check.agreedDate),
              style: TextStyle(fontSize: 18)),
      title: Column(
        children: [
          Row(
            children: [
              Text(
                "Número: ",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "${_check.number}",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Valor: ",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "${NumberFormat('##,##0.00', 'pt_BR').format(_check.value)}",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
      subtitle: _check.withdrawDate == null
          ? Text('não descontado',
              style: TextStyle(color: Theme.of(context).errorColor))
          : Text(
              "descontado: ${DateFormat('dd/MM/yyyy').format(_check.withdrawDate)}",
              style: TextStyle(fontSize: 12),
            ),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              child: Icon(
                _check.withdrawDate == null ? Icons.check_box : Icons.cancel,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                if (_check.withdrawDate == null) {
                  Navigator.of(context).pushNamed(
                    AppRoutes.CHECK_WITHDRAW_FORM_SCREEN,
                    arguments: CheckWithdrawFormArguments(
                        _check, AppRoutes.PAYMENT_CHECK_SCREEN),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Cancelar Desconto'),
                      content: Text('Confirmar o cancelamento ?'),
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
                        Provider.of<Checks>(context, listen: false)
                            .updateWithdrawDate(_check.id, null);
                      }
                    },
                  );
                }
              },
            ),
            InkWell(
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Confirme a exclusão'),
                      content: Text('Excluir o cheque ?'),
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
                        Provider.of<Checks>(context, listen: false)
                            .deleteCheck(_check.id);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
