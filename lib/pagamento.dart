import 'package:flutter/material.dart';
import 'package:personal_trainer/calendar/calendar_main.dart';
import 'package:personal_trainer/home.dart';
import 'package:personal_trainer/tiles/bottomNavigation.dart';

class Pagamento extends StatefulWidget {
  @override
  PagamentoState createState() => PagamentoState();
}

class PagamentoState extends State<Pagamento> {
  BottomNavigationClass bn = new BottomNavigationClass();

  @override
  void initState() {
    super.initState();    
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Controle de Contas'),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
         
        
        ],
      ),

      body: 
        GestureDetector(
          onPanUpdate: (details){
            if (details.delta.dx < 0){
              print("Esquerda vai para tela da direita");
              //aqui oh
              //Navigator.push(context,
                //MaterialPageRoute(builder: (context) => CalendarApp()),
              //);
            }
            if (details.delta.dx > 0){
              print("Direita vai para tela da esquerda");
              //aqui oh
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => TelaPrincipal()),
              );
            }
          },

            child: Column(            
              children: <Widget>[

          ],)
        ),
  
      bottomNavigationBar: bn,
    );
  }

}

