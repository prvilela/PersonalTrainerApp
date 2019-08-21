import 'package:flutter/material.dart';

class StudentTab extends StatefulWidget {
  @override
  _StudentTabState createState() => _StudentTabState();
}

class _StudentTabState extends State<StudentTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("teste",
        style: TextStyle(color: Colors.orange),),
    );
  }
}
