import '../widgets/session_by_day_item.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_by_day.dart';
import '../models/enums/week_day.dart';

class SessionDayScreen extends StatefulWidget {
  @override
  _SessionDayScreenState createState() => _SessionDayScreenState();
}

class _SessionDayScreenState extends State<SessionDayScreen> {
  bool _isLoading = false;
  var _selectedSessionDay;

  void onSearchWeekDayChanged(WeekDay weekDay) {
    setState(() {
      _isLoading = true;
    });
    Provider.of<SessionsByDay>(context, listen: false)
        .loadSessionsByDay(weekDay)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<SessionsByDay>(context, listen: false)
        .loadSessionsByDay(WeekDay.Monday)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    setState(() {
      _selectedSessionDay = WeekDay.Monday;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionsbyday = Provider.of<SessionsByDay>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sessões fixas por dia da semana'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(AppRoutes.CLIENT_FORM);
        //     },
        //   ),
        // ],
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
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<WeekDay>(
                          items: WeekDayList,
                          value: _selectedSessionDay,
                          hint: Text('Dia da semana'),
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            onSearchWeekDayChanged(value);
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
                        itemCount: sessionsbyday.itemsCount,
                        itemBuilder: (ctx, index) => Column(
                              children: <Widget>[
                                SessionByDayItem(sessionsbyday.items[index]),
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
