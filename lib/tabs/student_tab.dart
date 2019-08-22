import 'package:flutter/material.dart';

class StudentTab extends StatefulWidget {
  @override
  _StudentTabState createState() => _StudentTabState();
}

class _StudentTabState extends State<StudentTab> {

  final _formKey = GlobalKey();
  bool checkLose = false;
  bool checkMuscle = false;
  bool checkToned = false;

  @override
  Widget build(BuildContext context) {

    InputDecoration _buildDecoratiom(String label){
      return InputDecoration(
        labelText:label,
        labelStyle: TextStyle(color: Colors.deepOrange),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    }

    final _fieldStale = TextStyle(color: Colors.orange, fontSize: 16);

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          TextFormField(
            style: _fieldStale,
            decoration: _buildDecoratiom("Nome"),
            onSaved: (t){},
          ),
          TextFormField(
            style: _fieldStale,
            decoration: _buildDecoratiom("Data de Nascimento"),
            onSaved: (t){},
            validator: (t){},
          ),
          TextFormField(
            style: _fieldStale,
            decoration: _buildDecoratiom("CPF"),
            onSaved: (t){},
            validator: (t){},
          ),
          TextFormField(
            style: _fieldStale,
            decoration: _buildDecoratiom("E-mail"),
            onSaved: (t){},
            validator: (t){},
          ),
          TextFormField(
            style: _fieldStale,
            decoration: _buildDecoratiom("Telefone"),
            onSaved: (t){},
            validator: (t){},
          ),
          TextFormField(
            style: _fieldStale,
            decoration: _buildDecoratiom("Objetivos"),
            onSaved: (t){},
            validator: (t){},
          ),
          TextFormField(
            style: _fieldStale,
            decoration: _buildDecoratiom("Restrições"),
            maxLines: 4,
            onSaved: (t){},
            validator: (t){},
          ),
        ],
      )
    );
  }
}
