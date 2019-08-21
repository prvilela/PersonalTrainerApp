import 'package:flutter/material.dart';

class telaPrincipal extends StatefulWidget {
  String texto;
  telaPrincipal(this.texto);

  @override
  _telaPrincipalState createState() => _telaPrincipalState();
}

class _telaPrincipalState extends State<telaPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"), backgroundColor: Colors.orange,),
      body: 
      Column(children: <Widget>[
        Text(widget.texto)

      ],),
    );
  }
}