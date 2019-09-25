import 'package:flutter/material.dart';
import 'package:personal_trainer/screens/agendarTreino_screen.dart';

class HomeTab extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
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
                onPressed: (){},
              )
            ),
    
          ],
        )
      )



    ],);
  }
}
