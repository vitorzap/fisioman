import 'package:flutter/material.dart';
import '../utils/db_utils.dart';
import '../widgets/app_drawer.dart';

class UtilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Utilidades'),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            ListTile(
              leading: Icon(Icons.table_view),
              title: Text('Verificar/Criar tabelas'),
              trailing: ElevatedButton(
                child: Text('Executar'),
                onPressed: () async {
                  var msg = '';
                  var rowList;
                  rowList = await DbUtil.rawQuery(
                      "SELECT * FROM sqlite_master WHERE name ='clients' and type='table'");
                  if (rowList.length == 0) {
                    DbUtil.createTableClients();
                    msg = msg + "Tabela CLIENTES criada \n";
                  } else {
                    msg = msg + "Tabala CLIENTES já existe \n";
                  }
                  rowList = await DbUtil.rawQuery(
                      "SELECT * FROM sqlite_master WHERE name ='sessiondays' and type='table'");
                  if (rowList.length == 0) {
                    DbUtil.createTableSessionDays();
                    msg = msg + "Tabela SESSÕES FIXAS criada \n";
                  } else {
                    msg = msg + "Tabala SESSÕES FIXAS já existe \n";
                  }
                  rowList = await DbUtil.rawQuery(
                      "SELECT * FROM sqlite_master WHERE name ='payments' and type='table'");
                  if (rowList.length == 0) {
                    DbUtil.createTablePayments();
                    msg = msg + "Tabela PAGAMENTOS criada \n";
                  } else {
                    msg = msg + "Tabala PAGAMENTOS já existe \n";
                  }
                  rowList = await DbUtil.rawQuery(
                      "SELECT * FROM sqlite_master WHERE name ='checks' and type='table'");
                  if (rowList.length == 0) {
                    DbUtil.createTableChecks();
                    msg = msg + "Tabela CHEQUES criada \n";
                  } else {
                    msg = msg + "Tabala CHEQUES já existe \n";
                  }
                  rowList = await DbUtil.rawQuery(
                      "SELECT * FROM sqlite_master WHERE name ='sessions' and type='table'");
                  if (rowList.length == 0) {
                    DbUtil.createTableSessions();
                    msg = msg + "Tabela SESSÕES criada \n";
                  } else {
                    msg = msg + "Tabala SESSÕES já existe \n";
                  }

                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Concluido'),
                      content: Text(msg),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Ok'),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.table_view),
              title: Text('Excluir pagamentos liquidados a mais de um ano'),
              trailing: ElevatedButton(
                child: Text('Executar'),
                onPressed: () async {
                  final date = DateTime.now()
                      .subtract(Duration(days: 365))
                      .toIso8601String();
                  final rowsDeleted = await DbUtil.deleteByLessThan(
                      'payments', 'effectiveDate', date);
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Concluido'),
                      content: Text(
                          'Excluidos ${rowsDeleted.toString()} pagamentos'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Ok'),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.table_view),
              title: Text('Excluir cheques descontados a mais de um ano'),
              trailing: ElevatedButton(
                child: Text('Executar'),
                onPressed: () async {
                  final date = DateTime.now()
                      .subtract(Duration(days: 365))
                      .toIso8601String();
                  final rowsDeleted = await DbUtil.deleteByLessThan(
                      'checks', 'withdrawDate', date);
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Concluido'),
                      content:
                          Text('Excluidos ${rowsDeleted.toString()} cheques'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Ok'),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
