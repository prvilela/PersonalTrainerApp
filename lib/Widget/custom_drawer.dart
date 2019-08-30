import 'package:flutter/material.dart';
import 'package:personal_trainer/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
              decoration: BoxDecoration(
                gradient:LinearGradient(
                    colors: [Colors.deepOrange, Colors.orange, Colors.orange[300]],
                    begin:Alignment.topCenter,
                    end: Alignment.bottomCenter
                )
              ),
              );
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(top:100 ,left: 32, right: 16),
            children: <Widget>[
              DrawerTile(Icons.home,"Início",pageController,0) , 
              DrawerTile(Icons.person,"Alunos",pageController,1),
              DrawerTile(Icons.exit_to_app,"Sign out",pageController,2),
              
            ],
            
          )
        ],
      ),
    );
  }
}
