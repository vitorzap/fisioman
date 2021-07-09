import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/checks.dart';
import '../views/check_withdraw_form_screen.dart';
import '../utils/app_routes.dart';

class OpenCheckItem extends StatelessWidget {
  final Check _check;

  OpenCheckItem(this._check);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _check.agreedDate.isBefore(DateTime.now())
          ? Text(
              DateFormat('dd/MM/yyyy').format(_check.agreedDate),
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).errorColor),
            )
          : Text(DateFormat('dd/MM/yyyy').format(_check.agreedDate),
              style: TextStyle(fontSize: 18)),
      title: Text(_check.name, style: TextStyle(fontSize: 14)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_check.number),
          Text(NumberFormat("##,##0.00", "pt_BR").format(_check.value)),
        ],
      ),
      trailing: InkWell(
        child: Icon(
          Icons.check_box,
          color: Theme.of(context).primaryColor,
        ),
        onTap: () {
          if (_check.withdrawDate == null) {
            Navigator.of(context).pushNamed(
              AppRoutes.CHECK_WITHDRAW_FORM_SCREEN,
              arguments: CheckWithdrawFormArguments(
                  _check, AppRoutes.OPEN_CHECK_SCREEN),
            );
          }
        },
      ),
    );
  }
}
