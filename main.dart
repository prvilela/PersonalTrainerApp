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
      backgroundColor: Colors.deepOrange[800],
      body: Container(
        child: Column(    
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[        
            Padding(
              child:
                TextField(
                  decoration: InputDecoration(
                  labelText: "Digite seu email"           
                  ),
                ),                     
                padding: EdgeInsets.all(10),
            ),
          
            Padding(
              child:
              TextField(
                style: TextStyle(color: Colors.white), 
                decoration: InputDecoration(
                  labelText: "Digite sua senha",
                     
                ),
              ),
              padding: EdgeInsets.fromLTRB(10, 5, 10, 20),
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
              child: Text("Login"),            
            ),

            Text("Esqueci minha senha"),

           
            Text("Fazer Cadastro"),
            
          ],


        ),
      )
    );
  }
}
