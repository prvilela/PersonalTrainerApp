import 'package:flutter/material.dart';

class ChooseDialog extends StatelessWidget {

  ChooseDialog({this.names,this.titulo});

  final List<String> names;
  final String titulo;

  String escolha='';

  num select = -1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo),
      content: Container(
          height: MediaQuery.of(context).size.height  * 0.4,
          width: MediaQuery.of(context).size.height  * 0.3,
          child:
          ListView.builder(
              shrinkWrap: true,
              itemCount: names.length,
              itemBuilder: (BuildContext context, int index){
                return FlatButton(
                    highlightColor: Colors.orange,
                    color: select == index
                        ? Colors.orange
                        : Colors.white,
                    child: Text(names[index], style: TextStyle(fontSize: 20,),),
                    onPressed: (){
                      escolha = names[index];
                      Navigator.of(context).pop(escolha);
                    }
                );
              }
          )
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop(escolha);
          },
          child: Text("Cancelar", style: TextStyle(color: Colors.red),),
        )
      ],
    );
  }
}
