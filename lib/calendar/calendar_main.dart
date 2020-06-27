//  Copyright (c) 2019 Aleksander Woźniak

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/calendar/table_calendar.dart';
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
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
    };

    futuro(context);

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
    print(day);
    print(day.weekday);
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
        GestureDetector(
          onPanUpdate: (details){
            if (details.delta.dx < 0){
              print("Esquerda vai para tela da direita");
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => TelaPrincipal()),
              );
            }        
          },
          child:
            Column(
              children: <Widget>[
                _buildTableCalendarWithBuilders(),
                const SizedBox(height: 8.0),
                Expanded(child: _buildEventList()),
              ]
            ),
          ),   
                    
          
      bottomNavigationBar: bn,
    );

  }

    //Pega todos os dias e horas das aulas avulsas, para poder jogar no calendárioBuilder
    futuro(BuildContext context) async{
      var agora = DateTime.now();
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String sid = user.uid;
      QuerySnapshot list = await Firestore.instance.collection("aulas").where("id", isEqualTo: sid).getDocuments();
      var lista1 = list.documents.map((doc) => doc.data['data'] + " - " +doc.data['hora']);
      print(lista1);

      //funciona porem n adicona Tipo Iterable
      _events.putIfAbsent(agora.add(Duration(days: 4)), () => ['teste', 'fabio']);


      //var mapa2 = new Map<Iterable, Iterable>.fromIterable(lista1, value: (lista1) => lista1);

      print(_events);
      //print(mapa2);
    }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders(){
    return TableCalendar(
      locale: 'pt_PT',
      calendarController: _calendarController,
      events: _events,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
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
     //linha abaixo chama afunção "futuro", que busca as aulas individuais cadastradas
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
