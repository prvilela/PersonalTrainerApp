import 'package:flutter/material.dart';
import 'package:personal_trainer/calendar/calendar_main.dart';
import 'package:personal_trainer/home.dart';
import 'package:personal_trainer/pagamento.dart';

class BottomNavigationClass extends StatefulWidget{

  @override
  _BottomNavigationClassState createState() => _BottomNavigationClassState();
}

class _BottomNavigationClassState extends State<BottomNavigationClass> {
  List<BottomNavigationBarItem> items;

  @override
  void initState() {
    items = new List();
    items.add(new BottomNavigationBarItem(icon: new Icon(Icons.calendar_today, color: Colors.deepOrange),
    title: new Text('Agenda', style: TextStyle(color: Colors.white),)));
    items.add(new BottomNavigationBarItem(icon: new Icon(Icons.person_add, color: Colors.deepOrange),
    title: new Text('Home', style: TextStyle(color: Colors.white),)));
    items.add(new BottomNavigationBarItem(icon: new Icon(Icons.monetization_on, color: Colors.deepOrange),
    title: new Text('Fatura', style: TextStyle(color: Colors.white),)));
  }

  @override
  Widget build(BuildContext context){
    initState();
    return Material(
      child:
      BottomNavigationBar(
        items: items,
        onTap: (int item){
          int currentIndex = item;
          print("teste");
          print(currentIndex);

          if(currentIndex == 0){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=>CalendarApp()) 
            );
          }

          if(currentIndex == 1){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=>TelaPrincipal())
            );
          }

          if(currentIndex == 2){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=>Pagamento())
            );
          }
                 
        }
      )
    );
  }
}