import 'package:apppersonaltrainer/models/student.dart';
import 'package:apppersonaltrainer/models/user.dart';
import 'package:flutter/material.dart';

class PagamentoTile extends StatelessWidget {

  PagamentoTile({this.user,this.student,this.price, this.month});

  final Student student;
  final num price;
  final int month;
  final User user;

  final TextEditingController priceController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {

    final _fieldStale = TextStyle(color: Theme.of(context).primaryColor, fontSize: 20);

    InputDecoration _buildDecoratiom(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none
      );
    }

    int newMonth = month+1;

    if(month>12){
      newMonth = 1;
    }
    
    priceController.text = (price*student.quant).toStringAsFixed(2);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: (){},
        child: Card(
          child: ExpansionTile(
            title: Text(student.name,style:TextStyle(
                color: Colors.grey[700], fontSize: 20),),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      readOnly: true,
                      style: _fieldStale,
                      decoration: _buildDecoratiom("Quantidade de aulas:"),
                      initialValue: student.quant.toString(),
                    ),
                    TextFormField(
                      readOnly: true,
                      style: _fieldStale,
                      decoration: _buildDecoratiom("Preço das aulas:"),
                      initialValue: price.toString(),
                    ),
                    TextFormField(
                      readOnly: true,
                      style: _fieldStale,
                      decoration: _buildDecoratiom("Total:"),
                      controller: priceController,
                    ),
                    Divider(height: 2,color: Colors.grey,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton.icon(
                            onPressed: (){
                              student.mesIni = newMonth;
                              student.save();
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text("Adiar")
                        ),
                        FlatButton.icon(
                            onPressed: (){
                              student.mesIni = newMonth;
                              student.quant = 0;
                              user.pagamentos.add(num.parse(priceController.text));
                              user.saveData();
                              student.save();
                            },
                            icon: const Icon(Icons.payment),
                            label: const Text("Pagar")
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
