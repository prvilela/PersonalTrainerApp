import 'package:flutter/material.dart';
import 'custom_drawer_header.dart';
import 'drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(),
          ),
          ListView(
            children: <Widget>[
              CustomDrawerHeader(),
              const Divider(),
              DrawerTile(
                icon: Icons.home,
                title: 'Início',
                page: 0,
              ),
              DrawerTile(
                icon: Icons.today,
                title: 'Agenda',
                page: 1,
              ),
              const Divider(),
              DrawerTile(
                icon: Icons.school,
                title: 'Alunos',
                page: 2,
              ),
              DrawerTile(
                icon: Icons.assignment,
                title: 'Planos',
                page: 3,
              ),
              DrawerTile(
                icon: Icons.place,
                title: 'Academias',
                page: 4,
              ),
              const Divider(),
              DrawerTile(
                icon: Icons.timeline,
                title: 'Pagamentos',
                page: 5,
              ),
            ],
          )
        ],
      ),
    );
  }
}
