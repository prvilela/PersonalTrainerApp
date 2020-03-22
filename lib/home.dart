import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/Widget/custom_drawer.dart';
import 'package:personal_trainer/blocs/getStudent_bloc.dart';
import 'package:personal_trainer/blocs/getGym_bloc.dart';
import 'package:personal_trainer/calendar/calendar_main.dart';
import 'package:personal_trainer/login_bloc/facebook_login_button.dart';
import 'package:personal_trainer/main.dart';
import 'package:personal_trainer/pagamento.dart';
import 'package:personal_trainer/screens/gym_screen.dart';
import 'package:personal_trainer/screens/student_screen.dart';
import 'package:personal_trainer/tabs/home_tab.dart';
import 'package:personal_trainer/tabs/gym_tab.dart';
import 'package:personal_trainer/tabs/student_tab.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:personal_trainer/tiles/bottomNavigation.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  PageController _pageController= PageController();
  FirebaseAuth _firebaseAuth;
  BottomNavigationClass bn = new BottomNavigationClass();
  FacebookLoginButtonState flbs = new FacebookLoginButtonState();

  GetStudentBloc _getStudentBloc;
  GetGymBloc _getGymBloc;

  @override
  void initState() {
    super.initState();
    _getStudentBloc = GetStudentBloc();
    _getGymBloc = GetGymBloc();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[

            Scaffold(
              appBar: AppBar(
                title: Text("Agenda"),
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

              body: 
                GestureDetector(
                  onPanUpdate: (details){
                    if (details.delta.dx > 0){
                      print("Direita vai para tela da esquerda");
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CalendarApp()),
                      );
                    }
                    if (details.delta.dx < 0){
                      print("Esquerda vai para tela da direita");
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Pagamento()),
                      );
                    }
                  },
                  child:
                    HomeTab(),
                ),
                  bottomNavigationBar: bn,
            ),
          
            BlocProvider<GetStudentBloc>( 
              bloc: _getStudentBloc,
              child:
                Scaffold(
                  appBar: AppBar(
                    title: Text("Alunos"),
                    backgroundColor: Colors.deepOrange,
                    centerTitle: true,
                  ),
                  drawer: CustomDrawer(_pageController),
                  body: StudentTab(),
                  floatingActionButton: SpeedDial(
                    child: Icon(Icons.view_list),
                    backgroundColor: Colors.deepOrange,
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
                      ),
                      SpeedDialChild(
                        child: Icon(Icons.reorder),
                        backgroundColor: Colors.orange,
                        label:"Ordenar por nome do aluno",
                        labelStyle: TextStyle(fontSize: 14),
                        onTap: (){
                          print("aluno");
                          _getStudentBloc.setStudentCriteria(SortCriteria.ORDERNAME);
                        }
                      ),
                      SpeedDialChild(
                        child: Icon(Icons.reorder),
                        backgroundColor: Colors.orange,
                        label:"Ordenar por Academia",
                        labelStyle: TextStyle(fontSize: 14),
                        onTap: (){
                          _getStudentBloc.setStudentCriteria(SortCriteria.ORDERGYM);
                        }
                      ),
                      SpeedDialChild(
                        child: Icon(Icons.arrow_upward),
                        backgroundColor: Colors.orange,
                        label:"Alunos ativos acima",
                        labelStyle: TextStyle(fontSize: 14),
                        onTap: (){
                          _getStudentBloc.setStudentCriteria(SortCriteria.ORDERATIV);
                        }
                      )
                    ],
                  ),
                ), 
            ),
      

            BlocProvider<GetGymBloc>( 
              bloc: _getGymBloc,
              child:
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
                    backgroundColor: Colors.deepOrange,
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
                      ),
                      SpeedDialChild(
                        child: Icon(Icons.reorder),
                        backgroundColor: Colors.orange,
                        label:"Ordenar por nome",
                        labelStyle: TextStyle(fontSize: 14),
                        onTap: (){
                          print("academia");
                          _getGymBloc.setGymCriteria(SortCriterioGym.ORDERGYM);
                        }
                      ),
                    ],
                  ),
                )
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
                    // BlocProvider.of<AuthenticationBloc>(context).dispatch(
                    // LoggedOut(),
                    //);
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
            onPressed: () async { 
                                    
              signOut();            
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

  void signOut() async{
    await FirebaseAuth.instance.signOut();
    flbs.logout();
    Navigator.of(context, rootNavigator: true).pop('dialog'); 
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=> MyHomePage())
    );
  }
  
}
// \o/