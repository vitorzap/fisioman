import 'package:fisioman/views/payment_confirm_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/payments.dart';
import '../utils/app_routes.dart';

class ClientPaymentItem extends StatelessWidget {
  final Payment _payment;
  final TextEditingController _payDateController = new TextEditingController();

  ClientPaymentItem(this._payment);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (_payment.effectiveDate != null) {
          Navigator.of(context).pushNamed(
            AppRoutes.PAYMENT_CHECK_SCREEN,
            arguments: _payment,
          );
        }
      },
      leading: _payment.effectiveDate == null &&
              _payment.expectedDate.isBefore(DateTime.now())
          ? Text(
              DateFormat('dd/MM/yyyy').format(_payment.expectedDate),
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).errorColor),
            )
          : Text(DateFormat('dd/MM/yyyy').format(_payment.expectedDate),
              style: TextStyle(fontSize: 18)),
      title: Text(
        NumberFormat("##,##0.00", "pt_BR").format(_payment.amount),
      ),
      subtitle: _payment.effectiveDate == null
          ? Text('em Aberto',
              style: TextStyle(color: Theme.of(context).errorColor))
          : Text(
              "Pago: ${DateFormat('dd/MM/yyyy').format(_payment.effectiveDate)}",
              style: TextStyle(fontSize: 12),
            ),
      trailing: Container(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              child: Icon(
                _payment.effectiveDate == null ? Icons.check_box : Icons.cancel,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                if (_payment.effectiveDate == null) {
                  Navigator.of(context).pushNamed(
                    AppRoutes.PAYMENT_CONFIRM_FORM_SCREEN,
                    arguments: PaymentConfirmFormArguments(
                        _payment, AppRoutes.CLIENT_PAYMENT_SCREEN),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Cancelar Pagamento'),
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
                        Provider.of<Payments>(context, listen: false)
                            .updateDateEffective(_payment.id, null);
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
                      content: Text('Excluir o pagamento ?'),
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
                        Provider.of<Payments>(context, listen: false)
                            .deletePayment(_payment.id);
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
