import 'package:flutter/material.dart';
import 'package:personal_trainer/Widget/custom_drawer.dart';
import 'package:personal_trainer/screens/gym_screen.dart';
import 'package:personal_trainer/screens/student_screen.dart';
import 'package:personal_trainer/tabs/home_tab.dart';
import 'package:personal_trainer/tabs/gym_tab.dart';
import 'package:personal_trainer/tabs/student_tab.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer/blocs/bloc.dart';
import 'package:personal_trainer/blocs/authentication_bloc.dart';
import 'package:personal_trainer/Widget/custom_drawer.dart';
import 'package:personal_trainer/user_repository.dart';

class TelaPrincipal extends StatefulWidget {

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {

   PageController _pageController= PageController();
  
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
            actions: <Widget>[
              Container(
                child:
                  FlatButton(
                    child:
                      Padding(
                        child:
                          Icon(Icons.account_circle, color: Colors.white),
                          padding: EdgeInsets.fromLTRB(25, 0, 0, 0),  
                      ),
                    onPressed: (){
                      botaoSignOut(context);
                    },

                  ),

                  
                                                                      
              ),
            ]
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
            title: Text("Academias"),
            backgroundColor: Colors.deepOrange,
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: GymTab(),
          floatingActionButton: SpeedDial(
            child: Icon(Icons.view_list),
            backgroundColor: Colors.orange,
            children:[
              SpeedDialChild(
                child: Icon(Icons.add),
                backgroundColor: Colors.orange,
                label:"Adicionar uma academia",
                labelStyle: TextStyle(fontSize: 14),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>GymScreen())
                  );
                }
              )
            ],
          ),
        ),

        Scaffold(
          appBar: AppBar(
            title: Text("Exit"),
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


  void botaoSignOut(BuildContext context){
    var alert = AlertDialog(
      title: Text("Nome do usuario"),
      content: new Container(
        width: 300,
        height: 100,
        child: Column(children: <Widget>[        
          FlatButton(
            child: Text("Sign out"),
            onPressed: (){
              BlocProvider.of<AuthenticationBloc>(context).dispatch(
              LoggedOut()); 
              Navigator.pop(context);  
            },
          ),

          FlatButton(
            child: Text("Voltar"),
            onPressed: (){Navigator.pop(context);},

          )

          
        ],)
               
      ),
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      )
    );

    showDialog(
      context: context,
      builder: (BuildContext context){
        return alert;
      }
    );
 
  }

}