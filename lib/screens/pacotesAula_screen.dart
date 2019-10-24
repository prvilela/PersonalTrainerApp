import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/tiles/bottomNavigation.dart';

class PacoteAula extends StatefulWidget {
  @override
  _PacoteAulaState createState() => _PacoteAulaState();
}

class _PacoteAulaState extends State<PacoteAula>{
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BottomNavigationClass bn = new BottomNavigationClass();

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoratiom(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    } 
    final _fieldStale = TextStyle(color: Colors.orange[700], fontSize: 18);

    return Scaffold(
      appBar: AppBar(title: Text('Pacotes de Aula'),
        backgroundColor: Colors.deepOrange,
      ),

      body: Container(
        child:
        Text("")
      ),

      bottomNavigationBar: bn,
    
    );

  }

  void saveGym() async{
    
  }

}
