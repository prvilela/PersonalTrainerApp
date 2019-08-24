import 'dart:ui' as prefix0;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';

//codigo do github Personal Trainer Plinio
void main() => runApp(MyApp());

//teste


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(     
        primaryColor: Colors.deepOrange
      ),
      home: MyHomePage(title: 'Tela Login'),
      debugShowCheckedModeBanner: false,
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Container(   
        width: double.infinity,
        height: double.infinity,
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[ 

            //logotipo da tela de login
            Padding(
              child:
              SizedBox(
                child:
                Image.asset('assets/logotipo.png'),
                width: double.infinity,
                height: 120,    
              ),
              padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
            ),

            Padding(
              child:
                TextField(
                  style: TextStyle(color: Colors.white, fontSize: 18), 
                  decoration: InputDecoration(
                    icon: Icon(Icons.person, color: Colors.white),
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.white),                     
                    )                  
                  ),
                ),                     
                padding: EdgeInsets.fromLTRB(10, 40, 45, 10),
            ),
          
            Padding(
              child:
              TextField(
                style: TextStyle(color: Colors.white, fontSize: 18), 
                decoration: InputDecoration(
                  icon: Icon(Icons.lock, color: Colors.white),
                  hintText: "Senha", 
                  hintStyle: TextStyle(color: Colors.white), 
                  enabledBorder: UnderlineInputBorder(      
                    borderSide: BorderSide(color: Colors.white),   
                  )                             
                ),
                obscureText: true,
              ),
              padding: EdgeInsets.fromLTRB(10, 5, 45, 20),
            ), 
            //Botão Sign-in
            RaisedButton(
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context){
                    //telaSecundaria("asghduifasdfasdfbabsd");
                    return telaPrincipal();
                    }
                  )
                );
              },
              child: Text("Sign-in", 
                style: TextStyle(color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )
              ),
              padding: EdgeInsets.fromLTRB(45, 5, 45, 5),
                         
            ),

            //Esqueci minha senha
            Padding(
              child:
              Text("Esqueci minha senha", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
              
              padding: EdgeInsets.only(top: 5),
            ),

            //botão Cadastrar nova conta
            Align(
              child:
                Padding(
                  child:
                  RaisedButton(
                    child:           
                      Text("Cadastrar Conta", 
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      color: Colors.green,
                      onPressed: (){},                 
                  ),       
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                ),
                alignment: Alignment.bottomCenter,
            ),


            Padding(
              child:
              Text("Fazer login com:", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
              
              padding: EdgeInsets.only(top: 50),
            ),

            //2 botões: login facebook ou google
            Container(
              margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: <Widget>[
    
                    GestureDetector(
                      child:                    
                       Container(
                        width: 100,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                          image:AssetImage('assets/facebook_icon.png'), 
                          fit:BoxFit.fitWidth
                          ),  
                        )
                      ),onTap:(){}                 
                    ),

                    GestureDetector(
                      child:                    
                       Container(
                        width: 100,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                          image:AssetImage('assets/google_icon.png'), 
                          fit:BoxFit.fitWidth
                          ),            
                        )
                      ),onTap:(){}                                 
                    ),
                  ],
                ),
            ),
         
          ],
        ),
  
      )   

    );
  }
}
