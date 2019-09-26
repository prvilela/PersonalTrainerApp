import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:personal_trainer/time.dart';

class AgendarTreinoScreen extends StatefulWidget{
  final DocumentSnapshot agendar;
  AgendarTreinoScreen ({this.agendar});

_AgendarTreinoScreenState createState() => _AgendarTreinoScreenState(agendar);

}

class _AgendarTreinoScreenState extends State<AgendarTreinoScreen> with AutomaticKeepAliveClientMixin{
  _AgendarTreinoScreenState(DocumentSnapshot agendar);

  TimeState t1 = new TimeState();
  final controllerDate = TextEditingController();
  final controllerTime = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: Text("Agendar Treino"),
      backgroundColor: Colors.deepOrange,
      actions: <Widget>[
        StreamBuilder<bool>(
            builder: (context, snapshot) {
              return IconButton(icon: Icon(Icons.save),
                onPressed: (){},
              );
            }
          )

      ],

      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: _buildDecoration("CPF:"),
            ),
            SizedBox(height: 8.0),

            TextFormField(
              controller: controllerDate,
              decoration: _buildDecorationDate("Data:"),
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                DataInputFormatter(),
              ],
            ),
            SizedBox(height: 8.0),

            TextFormField(
              controller: controllerTime,
              decoration: _buildDecorationTime("Horario:"),
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(height: 8.0),

            TextFormField(
              decoration: _buildDecoration("Academia:"),
            ),

          ],
        ),
      ),
    );
  }



  InputDecoration _buildDecoration(String label) {
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

    InputDecoration _buildDecorationDate(String label) {
      return InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () => 
          controllerDate.text = t1.selectDate(context) as String,        
                   
        ),
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    }

    InputDecoration _buildDecorationTime(String label) {
      return InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(Icons.access_time),
          onPressed: () =>
          setState((){ controllerTime.text = t1.selectTime(context) as Str ing;})
        ),
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    }

  @override
  bool get wantKeepAlive => true;

}

