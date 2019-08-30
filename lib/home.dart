import 'package:flutter/material.dart';
import 'package:personal_trainer/Widget/custom_drawer.dart';
import 'package:personal_trainer/screens/student_screen.dart';
import 'package:personal_trainer/tabs/home_tab.dart';
import 'package:personal_trainer/tabs/student_tab.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer/blocs/bloc.dart';
import 'package:personal_trainer/blocs/authentication_bloc.dart';


class TelaPrincipal extends StatefulWidget {

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {

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
          ),
          drawer: CustomDrawer(_pageController),
          body: StudentTab(),
          floatingActionButton: SpeedDial(
            child: Icon(Icons.view_list),
            backgroundColor: Colors.orange,
            children:[
              SpeedDialChild(
                child: Icon(Icons.add),
                backgroundColor: Colors.orange,
                label:"Adicionar um aluno",
                labelStyle: TextStyle(fontSize: 14),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>StudentScreen())
                  );
                }
              )
            ],
          ),
        ),

        Scaffold(
          appBar: AppBar(
            title: Text("Home"),
            backgroundColor: Colors.deepOrange,
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: Container(
            child: 
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).dispatch(
                  LoggedOut(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}