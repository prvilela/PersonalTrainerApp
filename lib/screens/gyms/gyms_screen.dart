import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:apppersonaltrainer/common/custom_drawer/custom_drawer.dart';
import 'package:apppersonaltrainer/models/gym_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import 'components/gym_tile.dart';

class GymsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Academia'),
        centerTitle: true,
      ),
      body: Consumer<GymManager>(
        builder: (_,gymManger,__){
          final filteredGym = gymManger.filteredGym;
          if(filteredGym.isNotEmpty) {
            return AlphabetListScrollView(
              indexedHeight: (index) => 160,
              strList: gymManger.names,
              showPreview: true,
              itemBuilder: (_, index) {
                return GymTile(filteredGym[index]);
              },
            );
          }else{
            return Container();
          }
        },
      ),
      floatingActionButton: Consumer<GymManager>(
        builder: (_,planManager,__){
          return SpeedDial(
            child: Icon(Icons.view_list),
            backgroundColor: Colors.orange,
            elevation: 0,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.place),
                  backgroundColor: Theme.of(context).primaryColor,
                  label: "Adicionar um academia",
                  labelStyle: TextStyle(fontSize: 14),
                  onTap: (){
                    Navigator.of(context).pushNamed('/edit_gym');
                  }
              ),
            ],
          );
        },
      ),
    );
  }
}
