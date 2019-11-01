//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0
import 'package:flutter/material.dart';
import 'package:personal_trainer/home.dart';
import 'package:personal_trainer/tiles/bottomNavigation.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendário',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarPage(title: 'Calendário'),
    );
  }
}

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  DateTime _selectedDay = DateTime.now();
  BottomNavigationClass bn = new BottomNavigationClass();
 
  @override
  void initState() {
    super.initState();
    _events = {
      //_selectedDay: ['Event A7= "teste"', 'Event B7', 'Event C7', 'Event D7'],
      //_selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
    };
    
    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void onDaySelected(DateTime day, List events1){
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events1;
    });
  }

  void adicionarTreinos(DateTime day, List events1){
    setState(() {
      //essa linha de baixo, molde para passar dados para o calendáriooooooooo
      _events = { day: [events1]};
      _selectedEvents = events1;
      print(day);
      print(events1);
      print("topzaooooooooooooooooooooooooooooooooooooooooooooooooooo");
    });
    onDaySelected(day, events1);
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.title),
        backgroundColor: Colors.deepOrange,
        leading: IconButton(icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TelaPrincipal()),))
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          _buildTableCalendar(),
          // _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          //_buildButtons(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
      bottomNavigationBar: bn,
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange,
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: onDaySelected,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }
}