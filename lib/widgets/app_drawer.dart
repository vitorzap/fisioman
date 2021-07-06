import 'package:flutter/material.dart';
import '../utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Bem vindo'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Clientes'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today_sharp),
            title: Text('Aulas'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.SESSION_DAY_SCREEN);
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pagamentos em Aberto'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.OPEN_PAYMENT_SCREEN);
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Cheques não descontados'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.OPEN_CHECK_SCREEN);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Utilitários'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.UTILIDADES);
            },
          ),
        ],
      ),
    );
  }
}
