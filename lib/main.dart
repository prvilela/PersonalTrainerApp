import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/screens/personal_screen.dart';
import 'package:personal_trainer/blocs/personal_bloc.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer/blocs/bloc.dart';
import 'package:personal_trainer/user_repository.dart';
import 'bloc_provider.dart';
import 'package:personal_trainer/user_repository.dart';
import 'package:personal_trainer/login_bloc/login_bloc.dart';
import 'login_bloc/login_form.dart';

//codigo do github Personal Trainer Plinio
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(     
        primaryColor: Colors.deepOrange
      ),
      home: MyHomePage(userRepository: new UserRepository()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  //final String title;
  final UserRepository _userRepository;

   //MyHomePage({Key key, this.title}) : super(key: key);

   MyHomePage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    final myControllerEmail = TextEditingController();
    final myControllerPassword = TextEditingController();

    final FirebaseAuth _firebaseAuth;
    final GoogleSignIn _googleSignIn;

    LoginBloc _loginBloc;
    UserRepository get _userRepository => widget._userRepository;

    _MyHomePageState({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignin ?? GoogleSignIn();
      
    //final UserRepository _userRepository = UserRepository();
    AuthenticationBloc _authenticationBloc;

     @override
    void initState() {
      super.initState();
      _loginBloc = LoginBloc(
        userRepository: _userRepository,
      );
    }
    
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

            //campos de login, n descomentar ainda se n da merdaaaaaaaaaa
            /*BlocProvider<LoginBloc>(
              bloc: _loginBloc,
              child: LoginForm(userRepository: _userRepository),
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

    @override
    void dispose() {
      _authenticationBloc.dispose();
      _loginBloc.dispose();
      super.dispose();
    }

  }
}
