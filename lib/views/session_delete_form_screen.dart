import 'package:fisioman/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sessions.dart';

class SessionDeleteFormScreen extends StatefulWidget {
  @override
  _SessionDeleteFormScreenState createState() =>
      _SessionDeleteFormScreenState();
}

class _SessionDeleteFormScreenState extends State<SessionDeleteFormScreen> {
  Future<void> _runDelete() async {
    final sessions = Provider.of<Sessions>(context, listen: false);
    try {
      var wGen = await sessions.deleteSessions();
      if (wGen >= 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$wGen sessões excluídas'),
          duration: Duration(seconds: 1),
        ));
      } else {
        wGen = wGen * -1;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Das sessões a serem excluídas $wGen foram efetivadas, impossível excluir'),
          duration: Duration(seconds: 1),
        ));
      }
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro [' + error.toString() + ']'),
          content: Text('Erro ao gerar sessões)'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    } finally {
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Excluir últimas sessões geradas',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _runDelete();
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              'Excluir últimas sessões geradas automaticamente a partir de sessões fixas',
              style: TextStyle(
                  fontSize: 14, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
