import 'package:fisioman/providers/session_days.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clients.dart';
import '../widgets/client_item.dart';
import '../utils/app_routes.dart';

class ClientScreen extends StatefulWidget {
  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  bool _isLoading = true;
  TextEditingController _controller = new TextEditingController();

  void onSearchTextChanged(String filter) {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Clients>(context, listen: false).loadClients(filter).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // DbUtil.deleteTable('clients');
    // DbUtil.CreateTableClients();
    // DbUtil.AlterTableClients();
    // DbUtil.createTableSessionDays();
    // DbUtil.createTablePayments();
    // DbUtil.createTableSessions();
    // DbUtil.alterTableSessions();

    Provider.of<Clients>(context, listen: false).loadClients('').then((_) {
      Provider.of<SessionDays>(context, listen: false)
          .loadSessionDays()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clients = Provider.of<Clients>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.CLIENT_FORM);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                new Container(
                  color: Theme.of(context).primaryColor,
                  child: new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Card(
                      child: new ListTile(
                        leading: new Icon(Icons.search),
                        title: new TextField(
                          controller: _controller,
                          decoration: new InputDecoration(
                              hintText: 'Pesquisar', border: InputBorder.none),
                          onChanged: (value) => onSearchTextChanged(value),
                        ),
                        trailing: new IconButton(
                          icon: new Icon(Icons.cancel),
                          onPressed: () {
                            _controller.clear();
                            onSearchTextChanged('');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                        itemCount: clients.itemsCount,
                        itemBuilder: (ctx, index) => Column(
                              children: <Widget>[
                                ClientItem(clients.items[index]),
                                Divider(),
                              ],
                            )),
                  ),
                ),
              ],
            ),
    );
  }
}
