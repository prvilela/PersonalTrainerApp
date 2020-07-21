import 'package:apppersonaltrainer/common/build_row.dart';
import 'package:apppersonaltrainer/models/plan.dart';
import 'package:flutter/material.dart';

class PlanTile extends StatelessWidget {

  const PlanTile(this.plan);

  final Plan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 48, 4),
      child: InkWell(
        onTap: (){
          Navigator.of(context).pushNamed('/edit_plan',arguments: plan);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8,bottom: 8),
            child: Column(
              children: <Widget>[
                BuildRow(text: "Nome: ", data: plan.name,),
                SizedBox(height: 4,),
                BuildRow(text: "Duração da Aula: ", data: plan.duration.toString(),),
                SizedBox(height: 4,),
                BuildRow(text: "Preço por Aula: ", data: plan.pricePerClass.toStringAsFixed(2),),
                SizedBox(height: 4,),
                BuildRow(text: "Duração: ", data: plan.quantityMonths.toString(),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
