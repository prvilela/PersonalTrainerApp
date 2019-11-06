import 'package:flutter/material.dart';
import 'package:personal_trainer/calendar/calendar_main.dart';
import 'package:personal_trainer/home.dart';
import 'package:personal_trainer/calendarioPacotes/pacotesAula_screen.dart';

class BottomNavigationClass extends StatefulWidget{

  @override
  _BottomNavigationClassState createState() => _BottomNavigationClassState();
}

class _BottomNavigationClassState extends State<BottomNavigationClass> {
  List<BottomNavigationBarItem> _items;

  int _currentIndex = 2;

  @override
  void initState() {
    _items = new List();
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.fitness_center, color: Colors.deepOrange,),
     title: new Text('Pacotes', style: TextStyle(color: Colors.white),)));
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.calendar_today, color: Colors.deepOrange),
     title: new Text('Agenda', style: TextStyle(color: Colors.white),)));
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.home, color: Colors.deepOrange),
     title: new Text('Home', style: TextStyle(color: Colors.white),)));
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.monetization_on, color: Colors.deepOrange),
     title: new Text('Fatura', style: TextStyle(color: Colors.white),)));
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.chat, color: Colors.deepOrange),
     title: new Text('Chat', style: TextStyle(color: Colors.white),)));
  }

  @override
  Widget build(BuildContext context){
    initState();
    return Material(
      child:
      BottomNavigationBar(
        items: _items,
        currentIndex: _currentIndex,
        onTap: (int item){
          _currentIndex = item;

          if(_currentIndex == 0){
            Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>PacoteAula())
                  );
          }

          if(_currentIndex == 1){
            Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>CalendarApp()) 
                  );
          }

          if(_currentIndex == 2){
            Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>TelaPrincipal())
                  );
          }

          if(_currentIndex == 3){
            Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>TelaPrincipal())
                  );
          }

          if(_currentIndex == 4){
            Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>TelaPrincipal())
                  );
          }
                 
        }
      )
    );
  }
}