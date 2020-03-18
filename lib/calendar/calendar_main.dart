//  Copyright (c) 2019 Aleksander Woźniak
import 'package:flutter/material.dart';
import 'package:personal_trainer/calendar/table_calendar.dart';
import 'package:personal_trainer/calendarioPacotes/pacotesAula_screen.dart';
import 'package:personal_trainer/home.dart';
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
  //DateTime dia;
  final String title;
  @override
  CalendarState createState() => CalendarState();

}

class CalendarState extends State<Calendar> with TickerProviderStateMixin {
  AnimationController _animationController;
  CalendarController _calendarController;
  BottomNavigationClass bn = new BottomNavigationClass();
  var diaSelecionado;

  @override
  void initState() {
    super.initState();
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
    });

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
      body: 
        GestureDetector(
          onPanUpdate: (details){
            if (details.delta.dx < 0){
              print("Esquerda vai para tela da direita");
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => TelaPrincipal()),
              );
            }
            else if (details.delta.dx > 0){
              print("Direita vai para tela da esquerda");
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => PacoteAula()),
              );
            }         
          },
          child:      
          Container(
            color: Colors.white, 
            child:  
            Column(
              children: <Widget>[
                _buildTableCalendar(),
                _buildButtons(),
                _buildContainer(),                                                     
              ],
            ),
            ) 
          
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

}