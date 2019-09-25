

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AgendarTreinoScreen extends StatefulWidget{
  final DocumentSnapshot agendar;
  AgendarTreinoScreen ({this.agendar});

_AgendarTreinoScreenState createState() => _AgendarTreinoScreenState(agendar);

}

class _AgendarTreinoScreenState extends State<AgendarTreinoScreen>{
  _AgendarTreinoScreenState(DocumentSnapshot agendar);

  @override
  
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Agendar Treino"),
      ),
      body: Container(),
    );
  }

}
