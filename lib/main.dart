import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer/blocs/authentication_bloc.dart';
import 'package:personal_trainer/user_repository.dart';
import 'package:personal_trainer/home.dart';
import 'package:personal_trainer/screens/splash_screen.dart';
import 'package:personal_trainer/login_bloc/login_screen.dart';
import 'package:personal_trainer/blocs/simple_bloc_delegate.dart';
import 'package:personal_trainer/blocs/bloc.dart';

//codigo do github Personal Trainer Plinio

void main() { 
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MyHomePage());
  }

class MyHomePage extends StatefulWidget {

   final UserRepository _userRepository= UserRepository();
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    //final myControllerEmail = TextEditingController();
    //final myControllerPassword = TextEditingController();
    final UserRepository _userRepository = UserRepository();
    AuthenticationBloc _authenticationBloc;
       
    @override
    void initState() {
      super.initState();
      _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
      _authenticationBloc.dispatch(AppStarted());    
    }

   /* 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Container(   
        width: double.infinity,
        height: double.infinity,
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[ 

            /*Padding(
              child: 
               //campos de login, n descomentar ainda se n da merdaaaaaaaaaa
                BlocProvider<LoginBloc>(
                  bloc: _loginBloc,
                  child: LoginForm(userRepository: _userRepository),
                ),
              padding: EdgeInsets.all(10),
            ),*/
      

            //logotipo da tela de login
            Padding(
              child:
              SizedBox(
                child:
                Image.asset('assets/logotipo.png'),
                width: double.infinity,
                height: 120,    
              ),
              padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
            ),

            Padding(
              child:
                TextField(
                  controller: myControllerEmail,
                  style: TextStyle(color: Colors.white, fontSize: 18), 
                  decoration: InputDecoration(
                    icon: Icon(Icons.person, color: Colors.white),
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.white),                     
                    )                  
                  ),                           
                ),                     
                padding: EdgeInsets.fromLTRB(10, 40, 45, 10),
            ),
          
            Padding(
              child:
              TextField(
                controller: myControllerPassword,
                style: TextStyle(color: Colors.white, fontSize: 18), 
                decoration: InputDecoration(
                  icon: Icon(Icons.lock, color: Colors.white),
                  hintText: "Senha", 
                  hintStyle: TextStyle(color: Colors.white), 
                  enabledBorder: UnderlineInputBorder(      
                    borderSide: BorderSide(color: Colors.white),   
                  )                             
                ),
                obscureText: true,
              ),
              padding: EdgeInsets.fromLTRB(10, 5, 45, 20),
            ), 
            //Botão Sign-in
            RaisedButton(
               child: Text("Sign-in", 
                style: TextStyle(color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )
              ),
              padding: EdgeInsets.fromLTRB(45, 5, 45, 5),

              //sing in from user_repository  
              onPressed: (){                                                 
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context){
                      return App();
                    }
                  )
                );            
              },                    
            ),

            //Esqueci minha senha
            Padding(
              child:
              Text("Esqueci minha senha", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
              
              padding: EdgeInsets.only(top: 5),
            ),

            //botão Cadastrar nova conta
            Align(
              child:
                Padding(
                  child:
                  RaisedButton(
                    child:           
                      Text("Cadastrar Conta", 
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      color: Colors.green,
                      onPressed: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context){
                              return PersonalScreen();
                            }
                          )
                        );
                      },                 
                  ),       
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                ),
                alignment: Alignment.bottomCenter,
            ),

            Padding(
              child:
              Text("Fazer login com:", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
              padding: EdgeInsets.only(top: 50),
            ),

            //2 botões: login facebook ou google
            Container(
              margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: <Widget>[  
                    GestureDetector(
                      child:                    
                       Container(
                        width: 100,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                          image:AssetImage('assets/facebook_icon.png'), 
                          fit:BoxFit.fitWidth
                          ),  
                        )
                      ),onTap:(){}                 
                    ),

                    GestureDetector(
                      child:                    
                       Container(
                        width: 100,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                          image:AssetImage('assets/google_icon.png'), 
                          fit:BoxFit.fitWidth
                          ),            
                        )
                      ),onTap:(){

                        //fUTURO LOGIN COM GOOGLE......                  
                      }                                 
                    ),
                  ],
                ),
            ),       
          ],
        ), 
      )   
    );

    
    }
    ////  }
    */
    @override
    Widget build(BuildContext context) {
      return BlocProvider(
        bloc: _authenticationBloc,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BlocBuilder(
            bloc: _authenticationBloc,
            builder: (BuildContext context, AuthenticationState state) {
              if (state is Uninitialized) {
                return SplashScreen();
              }
              if (state is Unauthenticated) {
                return LoginScreen(userRepository: _userRepository);
              }
              if (state is Authenticated) {
                return TelaPrincipal();
                /*Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context){
                      return TelaPrincipal();
                    }
                  )
                );*/

              }
            },
          ),
        ),
      );
    }

  @override
    void dispose() {
      _authenticationBloc.dispose();
      //_loginBloc.dispose();
      super.dispose();
  
    }
}