//  Copyright (c) 2019 Aleksander Woźniak
import 'package:flutter/material.dart';
import 'package:personal_trainer/calendar/table_calendar.dart';
import 'package:personal_trainer/tiles/bottomNavigation.dart';

class CalendarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Calendar(title: 'Calendário'),
      debugShowCheckedModeBanner: false
    );
  }
}

class Calendar extends StatefulWidget {
  Calendar({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
  AnimationController _animationController;
  CalendarController _calendarController;
  BottomNavigationClass bn = new BottomNavigationClass();

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

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

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.today),
            onPressed: (){
              print("todayyyyyyy");
              backToday();
            },
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          _buildTableCalendar(),
          // _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          _buildButtons(),
          const SizedBox(height: 8.0),
        ],
      ),

      bottomNavigationBar: bn,
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {  
    return TableCalendar(
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildButtons() {

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.access_time, size: 40, color: Colors.deepOrange),
              alignment: Alignment.center,
              tooltip: "Gerenciar",
              onPressed: (){
                //chamar pacotes comn o dia selecionado bem aqui!
              },
            )
          
          ],
        ),
        
      ],
    );
  }

  void backToday(){
    setState(() {
      _calendarController.setSelectedDay(
        DateTime.now()
      );
    });
  }

}