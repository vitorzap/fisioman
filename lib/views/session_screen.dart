import 'package:fisioman/providers/sessions.dart';
import 'package:fisioman/widgets/date_input.dart';
import 'package:fisioman/widgets/session_item.dart';
import 'package:intl/intl.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_routes.dart';

class SessionScreen extends StatefulWidget {
  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  bool _isLoading = true;
  TextEditingController _controller = new TextEditingController();

  void onSearchTextChanged(String filter) {
    if (filter.length != 10) {
      return;
    }
    DateTime dateTime;
    try {
      DateFormat inputFormat = DateFormat("dd/MM/yyyy");
      dateTime = inputFormat.parse(filter);
    } catch (error) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    Provider.of<Sessions>(context, listen: false)
        .loadSessionsByDate(dateTime)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _controller.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    Provider.of<Sessions>(context, listen: false)
        .loadSessionsByDate(DateTime.now())
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _selectDate(BuildContext context, TextEditingController controller) async {
    var _pickedDate = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: DateTime.now(),
      firstDate: DateTime(1919),
      lastDate: DateTime.now().add(Duration(days: 730)),
    );

    if (_pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(_pickedDate);
      });
      onSearchTextChanged(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessions = Provider.of<Sessions>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sessões por dia'),
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
                        // leading: new Icon(Icons.search),
                        leading: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  onSearchTextChanged(_controller.text);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.calendar_today_sharp),
                                onPressed: () {
                                  _selectDate(context, _controller);
                                },
                              ),
                            ],
                          ),
                        ),
                        title: TextField(
                          controller: _controller,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          inputFormatters: [DateTextFormatter()],
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
                        itemCount: sessions.itemsCount,
                        itemBuilder: (ctx, index) => Column(
                              children: <Widget>[
                                // Text(sessions.items[index].dateTime
                                //     .toIso8601String()),
                                SessionItem(sessions.items[index]),
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
