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
      Container(
        color: Colors.white,
        child:
      
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

            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[

                  Padding(              
                    padding: EdgeInsets.all(40),
                    child:

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    height: MediaQuery.of(context).size.height  * 0.6,
                    width: MediaQuery.of(context).size.width  * 1,

                    child: Text('')
                ),

                ),

                Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height  * 0.1,
                color: Colors.white,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[

                    Container(
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: FlatButton(
                        child:
                          Icon(Icons.payment, size: 40, color: Colors.orange),
                        onPressed: (){},
                      )
                    ),

                    Container(
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: FlatButton(
                        child:
                          Icon(Icons.email, size: 40, color: Colors.orange),
                        onPressed: (){},
                      )
                    ),

                  ],
                )
          )

          ],),
          
              ],
            )
            
        ),
  
      

    ),
    bottomNavigationBar: bn,
    );
  }

}

