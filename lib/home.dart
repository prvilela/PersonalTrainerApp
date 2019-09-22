import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:personal_trainer/Widget/custom_drawer.dart';
import 'package:personal_trainer/login_bloc/facebook_login_button.dart';
import 'package:personal_trainer/main.dart';
import 'package:personal_trainer/screens/gym_screen.dart';
import 'package:personal_trainer/screens/student_screen.dart';
import 'package:personal_trainer/tabs/home_tab.dart';
import 'package:personal_trainer/tabs/gym_tab.dart';
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
  PageController _pageController= PageController();
  FirebaseAuth _firebaseAuth;
  final facebookLogin = FacebookLogin();

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

 //deslogar do Gmail na tela home
  void botaoSignOut(BuildContext context){

    var alert = AlertDialog(
      title: Text("Conta", style: TextStyle(color: Colors.deepOrange)),
      contentPadding: EdgeInsets.all(0),
      content: new Container(
        width: 300,
        
        height: 100,
        child: Column(children: <Widget>[    

        Container(
          width: double.infinity,
          color: Colors.deepOrange, 
          child:     
          FlatButton(
            child:
              Text("Sign out", style: TextStyle(color: Colors.white, fontSize: 18)),
            onPressed: (){              
              BlocProvider.of<AuthenticationBloc>(context).dispatch(
              LoggedOut());
              //facebookLogin.logOut();       
     
              Navigator.pop(context);    
                         
            },
          ),
        ),  

        Container(
          width: double.infinity,
          child:
            FlatButton(
              child: Text("Voltar", style: TextStyle(color: Colors.deepOrange, fontSize: 16)),
              onPressed: (){Navigator.pop(context);},
            )
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