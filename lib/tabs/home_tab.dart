import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:personal_trainer/Widget/aula_tile.dart';
import 'package:personal_trainer/Widget/student_tile.dart';
import 'package:personal_trainer/screens/agendarTreino_screen.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int x=0;
  final controllerSearch = TextEditingController();

  @override
  Widget build(BuildContext context) { 
    if(x==0){

    return ListView(
      children: <Widget>[
        Column(children: <Widget>[  
          Container(
            width: double.infinity,
            height: 420,
            child:   
                  FutureBuilder(
                    future: FirebaseAuth.instance.currentUser(),
                    builder: (context, AsyncSnapshot<FirebaseUser>snapshot1) {
                      if(!snapshot1.hasData){
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
                          ),
                        );
                      }else{
                        return FutureBuilder<QuerySnapshot>(
                          future: Firestore.instance.collection("aulas").where(
                            "id", isEqualTo: snapshot1.data.uid).getDocuments(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
                                  ),
                                );
                              else
                              
                                return ListView.builder(
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    return AulaTile(snapshot.data.documents[index]);
                                  }
                                );
                                
                            },
                        );
                      }
                    }
                  ),
                              
          ),
          

          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FlatButton(
                    child:
                      Icon(Icons.filter_list, size: 40, color: Colors.orange),
                    onPressed: (){},
                  )
                ),

                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: FlatButton(
                    child:
                      Icon(Icons.add, size: 40, color: Colors.orange,),
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>AgendarTreinoScreen())
                      );
                    },
                  )
                ),

                Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FlatButton(
                    child:
                      Icon(Icons.search, size: 40, color: Colors.orange,),
                    onPressed: (){
                      setState(() {
                        x=1;
                      });

                    },
                  )
                ),

              ],
            )
          )

        ],),
      ],   
    );
  }

//quando selecionar Pesquisar, a tela mudará para a opção de pesquisa, caso cancele, voltará para o menu principal
//da home page
  if(x==1){
    return ListView(
      children: <Widget>[
        Column(children: <Widget>[

          Container(
            width: double.infinity,
            height: 433,
            child:
              ListView(
                children: <Widget>[

                ],
              )
          ),

          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[

                Container(
                    margin: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.orange),
                          top: BorderSide(color: Colors.orange),
                          left: BorderSide(color: Colors.orange),
                          right: BorderSide.none ),

                    ),

                    child: FlatButton(
                      child:
                      Icon(Icons.arrow_back, size: 40, color: Colors.orange),
                      onPressed: (){
                        setState(() {
                          x=0;
                        });
                      },
                    )
                ),

                Container(
                    padding: EdgeInsets.only(top: 15),
                    width: 152,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.orange),
                            top: BorderSide(color: Colors.orange))
                    ),
                    child: new TextFormField(
                      controller: controllerSearch,
                      style: TextStyle(color: Colors.deepOrange, fontSize: 16),
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        CpfInputFormatter(),
                      ],
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration.collapsed(
                          hintText: "Pesquise pelo CPF"


                      ),

                    )

                ),

                Container(
                    margin: EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.orange),
                          top: BorderSide(color: Colors.orange),
                          right: BorderSide(color: Colors.orange),)
                    ),
                    child: FlatButton(
                      child:
                      Icon(Icons.search, size: 40, color: Colors.orange,),
                      onPressed: (){
                        setState(() {
                          x=2;
                        });
                    },
                  )
                ),

              ],
            )
          )



        ],),
      ],
    );
    
      
  }

  if(x==2){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[

            Container(
                margin: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.orange),
                      top: BorderSide(color: Colors.orange),
                      left: BorderSide(color: Colors.orange),
                      right: BorderSide.none ),

                ),

                child: FlatButton(
                  child:
                  Icon(Icons.arrow_back, size: 40, color: Colors.orange),
                  onPressed: (){
                    setState(() {
                      x=0;
                    });
                  },
                )
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                padding: EdgeInsets.only(top: 15),
                width: 152,
                height: 50,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.orange),
                        top: BorderSide(color: Colors.orange))
                ),
                child: new TextFormField(
                  controller: controllerSearch,
                  style: TextStyle(color: Colors.deepOrange, fontSize: 16),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    CpfInputFormatter(),
                  ],
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration.collapsed(
                      hintText: "Pesquise pelo CPF"


                  ),

                )

            ),

            Container(
                margin: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.orange),
                      top: BorderSide(color: Colors.orange),
                      right: BorderSide(color: Colors.orange),)
                ),
                child: FlatButton(
                  child:
                  Icon(Icons.search, size: 40, color: Colors.orange,),
                  onPressed: (){
                    setState(() {
                      x=2;
                    });
                  },
                )
            ),

          ],
        ),
        FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser>snapshot1){
            if(!snapshot1.hasData){
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
                ),
              );
            }else{
              return FutureBuilder<QuerySnapshot>(
                future: Firestore.instance.collection("student").where(
                    "id", isEqualTo: snapshot1.data.uid).getDocuments(),
                builder: (context, snapshot){
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
                      ),
                    );
                  else
                    int x;
                    x = snapshot.data.documents.length;
                    int i,a=0;
                    for(i=0;i<x;i++){
                      if(controllerSearch.text == snapshot.data.documents[i]["cpf"]){
                        a=1;
                      }
                    }
                    if(a == 0){
                      return Text("Aluno não cadastrado");
                    }
                    else {
                      return SizedBox(
                        height: 450,
                        child: ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              return StudentTile(snapshot.data.documents[index]);
                            }
                        ),
                      );
                    }
                },
              );
            }
          },
        )
      ],
    );
  }

  }

  catchId(){
                  FutureBuilder(
                    future: FirebaseAuth.instance.currentUser(),
                      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                        if (snapshot.hasData) {          
                        String id = (snapshot.data.uid);
                        print(id); 
                        return Text("$id");                     
                        }                                          
                    }      
                  );
                  
                  }

  @override
  
  bool get wantKeepAlive => true;
}
