import 'package:flutter/material.dart';
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

    return Column(children: <Widget>[

      Container(
        width: double.infinity,
        height: 420,
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



    ],);
  }

//quando selecionar Pesquisar, a tela mudará para a opção de pesquisa, caso cancele, voltará para o menu principal
//da home page
  if(x==1){
    return Column(children: <Widget>[

      Container(
        width: double.infinity,
        height: 420,
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
                left: BorderSide(color: Colors.orange),)
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
              padding: EdgeInsets.all(0),
              width: 152,
              height: 50,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.orange), 
                top: BorderSide(color: Colors.orange))
              ),         
              child: new TextFormField(
                controller: controllerSearch,
                style: TextStyle(color: Colors.deepOrange, fontSize: 16),

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
                  
                },
              )
            ),
    
          ],
        )
      )



    ],);
    
      
  }

  }
}
