import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:apppersonaltrainer/common/custom_drawer/custom_drawer.dart';
import 'package:apppersonaltrainer/models/planManager.dart';
import 'package:apppersonaltrainer/screens/plans/components/plan_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class PlansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Planos'),
        centerTitle: true,
      ),
      body: Consumer<PlanManager>(
        builder: (_,planManger,__){
          final filteredPlan = planManger.filteredPlan;
          if(filteredPlan.isNotEmpty) {
            return AlphabetListScrollView(
              indexedHeight: (index) => 124,
              strList: planManger.names,
              showPreview: true,
              itemBuilder: (_, index) {
                return PlanTile(filteredPlan[index]);
              },
            );
          }else{
            return Container();
          }
        },
      ),
        floatingActionButton: Consumer<PlanManager>(
          builder: (_,planManager,__){
            return SpeedDial(
              child: Icon(Icons.view_list),
              backgroundColor: Colors.orange,
              elevation: 0,
              children: [
                SpeedDialChild(
                    child: Icon(Icons.add_box),
                    backgroundColor: Theme.of(context).primaryColor,
                    label: "Adicionar um plano",
                    labelStyle: TextStyle(fontSize: 14),
                    onTap: (){
                      Navigator.of(context).pushNamed('/edit_plan');
                    }
                ),
              ],
            );
          },
        ),
    );
  }
}
