import 'package:flutter/material.dart';

class BottomNavigationClass extends StatelessWidget{

  List<BottomNavigationBarItem> _items;
  int _currentIndex = 2;

  @override
  void initState() {
    _items = new List();
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.fitness_center, color: Colors.deepOrange,), title: new Text('')));
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.calendar_today, color: Colors.deepOrange), title: new Text('')));
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.home, color: Colors.deepOrange), title: new Text('')));
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.monetization_on, color: Colors.deepOrange), title: new Text('')));
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.chat, color: Colors.deepOrange), title: new Text('')));
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
        },
      ),
    );
  }


}