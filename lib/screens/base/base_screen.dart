import 'package:apppersonaltrainer/common/custom_drawer/custom_drawer.dart';
import 'package:apppersonaltrainer/models/google_sign.dart';
import 'package:apppersonaltrainer/models/page_manager.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:apppersonaltrainer/screens/gyms/gyms_screen.dart';
import 'package:apppersonaltrainer/screens/pagamentos/pagamentos_screen.dart';
import 'package:apppersonaltrainer/screens/plans/plans_screen.dart';
import 'package:apppersonaltrainer/screens/students/students_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  final PageController pageController = PageController();
  final date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: <Widget>[
          Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: const Text("Home"),
            ),
            body: Consumer<UserManager>(builder: (_, userManager, __) {
              if (date.day == 1 && userManager.user != null) {
                userManager.user.pagamentos.clear();
                userManager.user.saveData();
              }
              return Container(
                  height: double.infinity,
                  child: FittedBox(
                    child: Image.asset(
                      'assets/gym.jpg',
                    ),
                    fit: BoxFit.fitHeight,
                  ));
            }),
          ),
          Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: const Text("Agenda"),
            ),
          ),
          StudentsScreen(),
          PlansScreen(),
          GymsScreen(),
          PagamentosScreen()
        ],
      ),
    );
  }
}
