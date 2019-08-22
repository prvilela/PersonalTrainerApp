import 'package:flutter/material.dart';
import 'package:personal_trainer/Widget/custom_drawer.dart';
import 'package:personal_trainer/tabs/home_tab.dart';
import 'package:personal_trainer/tabs/student_tab.dart';

class telaPrincipal extends StatefulWidget {

  @override
  _telaPrincipalState createState() => _telaPrincipalState();
}

class _telaPrincipalState extends State<telaPrincipal> {

  final _pageController= PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("Home"),
            backgroundColor: Colors.deepOrange,
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: HomeTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Alunos"),
            backgroundColor: Colors.orange,
            centerTitle: true,
            actions: <Widget>[
              IconButton(icon: Icon(Icons.remove),onPressed: (){},),
              IconButton(icon: Icon(Icons.save),onPressed: (){},)
            ],
          ),
          drawer: CustomDrawer(_pageController),
          body: StudentTab(),

        )
      ],
    );
  }
}