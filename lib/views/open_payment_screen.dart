import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/payments.dart';
import '../widgets/open_payment_item.dart';
import '../widgets/app_drawer.dart';
import '../utils/app_routes.dart';

class OpenPaymentScreen extends StatefulWidget {
  @override
  _OpenPaymentScreenState createState() => _OpenPaymentScreenState();
}

class _OpenPaymentScreenState extends State<OpenPaymentScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<Payments>(context, listen: false).loadOpenPayments().then((_) {
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
    final pagamentosAberto = Provider.of<Payments>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagamentos em Aberto'),
        actions: <Widget>[],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: pagamentosAberto.itemsCount,
                itemBuilder: (ctx, index) => Column(
                  children: <Widget>[
                    OpenPaymentItem(pagamentosAberto.items[index]),
                    // Divider(),
                  ],
                ),
              ),
            ),
    );
  }
}
