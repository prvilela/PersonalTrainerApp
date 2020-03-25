//  Copyright (c) 2019 Aleksander Woźniak
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:personal_trainer/calendar/table_calendar.dart';
import 'package:personal_trainer/calendarioPacotes/pacotesAula_screen.dart';
import 'package:personal_trainer/home.dart';
import 'package:personal_trainer/tiles/bottomNavigation.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  //DateTime dia;
  final String title;
  @override
  CalendarState createState() => CalendarState();

}

class CalendarState extends State<Calendar> with TickerProviderStateMixin {
  AnimationController _animationController;
  CalendarController _calendarController;
  Map<DateTime, List> _events;
  List _selectedEvents;

  BottomNavigationClass bn = new BottomNavigationClass();
  var diaSelecionado;

  @override
  void initState() {
    super.initState();
    
    final _selectedDay = DateTime.now();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    initializeDateFormatting();

    _animationController.forward();
    _events = {
      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
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

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      diaSelecionado = day;
      _selectedEvents = events;
    });

  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
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
      body:       
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildTableCalendar(),
              const SizedBox(height: 8.0),
              Expanded(child: _buildEventList()),  

              
            ]               
          ),           
        
           
          
      bottomNavigationBar: bn,
    );
 
  }


  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {  
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      locale: 'pt_PT',
      startingDayOfWeek: StartingDayOfWeek.sunday,
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
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
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
                //chamar tela pacotes com o dia selecionado daqui           
                //obs: diaSelecionado está no formato DateTime, vem com horas, caso seja necessário alterar -->
                //isto futuramente, mas cuidado já que ele é passado para a classe pacotesAula_screen que recebe -->
                //no mesmo formato
                if(diaSelecionado != 'null'){
                  print(diaSelecionado);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>PacoteAula()),
                  );                 
                }
                else{
                  print("Selcione uma data");
                }

              },
            )
          
          ],
        ),
        
      ],
    );
  }

  Widget _buildContainer(){
    return Container(
      height: MediaQuery.of(context).size.height  * 0.3625,
      width: MediaQuery.of(context).size.width  * 1,
      color: Colors.white,
    );
  }

  void backToday(){
    setState(() {
      _calendarController.setSelectedDay(
        DateTime.now()
      );
    });
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
