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
//import 'package:personal_trainer/flutter_facebook_login.dart';

//import com.facebook.FacebookSdk;
//import com.facebook.appevents.AppEventsLogger;
//codigo do github Personal Trainer Plinio

void main() { 
  WidgetsFlutterBinding.ensureInitialized(); //meu sem essa linha aqui nem vai man, att do flutter
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MyHomePage());
  }

class MyHomePage extends StatefulWidget {
   final UserRepository _userRepository= UserRepository();
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    final UserRepository _userRepository = UserRepository();
    AuthenticationBloc _authenticationBloc;
    @override
    void initState() {
      super.initState();
      _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
      _authenticationBloc.dispatch(AppStarted());    
    }

    @override
    Widget build(BuildContext context) {
      return BlocProvider(
        bloc: _authenticationBloc,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BlocBuilder(
            bloc: _authenticationBloc,
            builder: (BuildContext context, AuthenticationState state) {
                       
              if (state is Unauthenticated) {
                return LoginScreen(userRepository: _userRepository);
              }
              if (state is Authenticated) {
                return TelaPrincipal();       
              }

              return SplashScreen();
              
            },
          ),
        ),
      );
    }

  @override
    void dispose() {
      _authenticationBloc.dispose();
      super.dispose();
    }

    
}