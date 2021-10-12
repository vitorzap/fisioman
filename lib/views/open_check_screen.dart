import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/checks.dart';
import '../widgets/open_check_item.dart';
import '../widgets/app_drawer.dart';

class OpenCheckScreen extends StatefulWidget {
  @override
  _OpenCheckScreenState createState() => _OpenCheckScreenState();
}

class _OpenCheckScreenState extends State<OpenCheckScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<Checks>(context, listen: false).loadOpenChecks().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final openChecks = Provider.of<Checks>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cheques não descontados'),
        actions: <Widget>[],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: openChecks.itemsCount,
                itemBuilder: (ctx, index) => Column(
                  children: <Widget>[
                    OpenCheckItem(openChecks.items[index]),
                    // Divider(),
                  ],
                ),
              ),
            ),
    );
  }
}
