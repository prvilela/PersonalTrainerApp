import 'package:apppersonaltrainer/common/build_row.dart';
import 'package:apppersonaltrainer/models/gym.dart';
import 'package:flutter/material.dart';

class GymTile extends StatelessWidget {

  const GymTile(this.gym);

  final Gym gym;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 48, 4),
      child: InkWell(
        onTap: (){
          Navigator.of(context).pushNamed('/edit_gym',arguments: gym);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8,bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                BuildRow(text: "Nome: ", data: gym.name,),
                SizedBox(height: 4,),
                BuildRow(text: "Telefone: ", data: gym.phone,),
                SizedBox(height: 4,),
                BuildRow(text: "Preço da Academia: ", data: gym.price.toString(),),
                SizedBox(height: 4,),
                Text(
                    'Endereço:',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.orange[700], fontSize: 16)
                ),
                Text(
                    gym.rua,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.orange[700], fontSize: 16)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
