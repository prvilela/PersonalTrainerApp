import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MyApp());

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
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[        
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
                padding: EdgeInsets.fromLTRB(10, 10, 45, 10),
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

            RaisedButton(
              
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context){
                    //telaSecundaria("asghduifasdfasdfbabsd");
                    return telaPrincipal("teste");               
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

            Padding(
              child:
              Text("Esqueci minha senha", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
              
              padding: EdgeInsets.only(top: 10)
            ),

              Padding(
                child:
                Row(children: <Widget>[
                // Align(alignment: CrossAxisAlignment.end,), 
                  Text("Criar Conta"),     
                ],),   
                padding: EdgeInsets.all(10),
              )

          ],

          
          
           
        ),

        

      )
    );
  }
}
