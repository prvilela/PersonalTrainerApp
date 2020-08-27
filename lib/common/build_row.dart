import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildRow extends StatelessWidget {

  const BuildRow({this.text,this.data});

  final String text;
  final String data;
  @override
  Widget build(BuildContext context) {
    final _fieldStale = TextStyle(color: Colors.orange[700], fontSize: 16);
    return Row(
      children: <Widget>[
        Text(text, style: _fieldStale,),
        Text(data, style: _fieldStale,)
      ],
    );
  }
}
