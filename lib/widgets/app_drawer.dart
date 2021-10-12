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
            title: Text('Sessões fixas por dia da semana'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.SESSION_DAY_SCREEN);
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Sessões por dia'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.SESSION_SCREEN);
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt_outlined),
            title: Text('Gerar sessões por dia a partir de sessões fixas'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.SESSION_GENERATE_FORM_SCREEN);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outlined),
            title: Text('Excluir últimas sessões geradas'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.SESSION_DELETE_FORM_SCREEN);
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
