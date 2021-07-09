import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/payments.dart';
import '../views/payment_confirm_form_screen.dart';
import '../utils/app_routes.dart';

class OpenPaymentItem extends StatelessWidget {
  final Payment _payment;
  final TextEditingController _payDateController = new TextEditingController();

  OpenPaymentItem(this._payment);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _payment.expectedDate.isBefore(DateTime.now())
          ? Text(
              DateFormat('dd/MM/yyyy').format(_payment.expectedDate),
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).errorColor),
            )
          : Text(DateFormat('dd/MM/yyyy').format(_payment.expectedDate),
              style: TextStyle(fontSize: 18)),
      title: Text(_payment.name, style: TextStyle(fontSize: 14)),
      subtitle:
          Text(NumberFormat("##,##0.00", "pt_BR").format(_payment.amount)),
      trailing: InkWell(
        child: Icon(
          Icons.check_box,
          color: Theme.of(context).primaryColor,
        ),
        onTap: () {
          if (_payment.effectiveDate == null) {
            Navigator.of(context).pushNamed(
              AppRoutes.PAYMENT_CONFIRM_FORM_SCREEN,
              arguments: PaymentConfirmFormArguments(
                  _payment, AppRoutes.OPEN_PAYMENT_SCREEN),
            );
          }
        },
      ),
    );
  }
}
