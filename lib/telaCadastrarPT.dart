import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class telaCadastrarPt extends StatefulWidget {

  @override
  _telaCadastrarPtState createState() => _telaCadastrarPtState();
}

class _telaCadastrarPtState extends State<telaCadastrarPt> {

  final _pageController= PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("Cadastrar Personal"),
            backgroundColor: Colors.deepOrange,
            centerTitle: true,
          ),
          
          body: 
            Container(
               child:
                Column(
                  children: <Widget>[ 
                    Padding(
                      child:
                      TextField(
                        style: TextStyle(color: Colors.white, fontSize: 18), 
                        decoration: InputDecoration(
                        icon: Icon(Icons.email, color: Colors.deepOrange),
                        hintText: "E-mail", 
                        hintStyle: TextStyle(color: Colors.deepOrange), 
                          enabledBorder: UnderlineInputBorder(      
                            borderSide: BorderSide(color: Colors.deepOrange),   
                          )                                
                        ),
                      ),
                      padding: EdgeInsets.only(top: 150),
                    ),
                    TextField(
                      style: TextStyle(color: Colors.white, fontSize: 18), 
                      decoration: InputDecoration(
                      icon: Icon(Icons.lock, color: Colors.deepOrange),
                      hintText: "Senha", 
                      hintStyle: TextStyle(color: Colors.deepOrange), 
                        enabledBorder: UnderlineInputBorder(      
                          borderSide: BorderSide(color: Colors.deepOrange),   
                        )                                
                      ),
                    ),

                    TextField(
                      style: TextStyle(color: Colors.white, fontSize: 18), 
                      decoration: InputDecoration(
                      icon: Icon(Icons.lock, color: Colors.deepOrange),
                      hintText: "Repitir senha", 
                      hintStyle: TextStyle(color: Colors.deepOrange), 
                        enabledBorder: UnderlineInputBorder(      
                          borderSide: BorderSide(color: Colors.deepOrange),   
                        )                                
                      ),
                    ),

                    Padding(
                      child:
                      FlatButton(
                        child:
                          Text("Cadastrar",
                            style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            ),
                          ),
                          onPressed: (){},
                          color: Colors.deepOrange,
                      ),
                      padding: EdgeInsets.all(15),
                    )
                  ]
                )

            ) 
          
        ),
      ],
    );
  }
}