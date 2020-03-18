import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer/blocs/authentication_bloc.dart';
import 'package:personal_trainer/blocs/authentication_event.dart';
import 'package:personal_trainer/login_bloc/login_form.dart';
import 'package:personal_trainer/login_bloc/login_screen.dart';
import 'package:personal_trainer/register/personal_register_data.dart';
import 'package:personal_trainer/register/register_bloc.dart';
import 'package:personal_trainer/register/register_event.dart';
import 'package:personal_trainer/register/register_state.dart';
import 'package:personal_trainer/register/register_button.dart';
import 'package:personal_trainer/user_repository.dart';

import '../home.dart';
import '../main.dart';

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserRepository ur = new UserRepository();

  FirebaseAuth _firebaseAuth;
  _RegisterFormState({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    emailController.addListener(_onEmailChanged);
    passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    var email = emailController.text;
    var password = passwordController.text;

    return BlocListener(
      bloc: _registerBloc,
      listener: (BuildContext context, RegisterState state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
          //Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>PersonalData())
          );
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Confirme seu email!'),],
              ),
            ),
          );
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.black,
              ),
            );
        }
      },
      child: BlocBuilder(
        bloc: _registerBloc,
        builder: (BuildContext context, RegisterState state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[                
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email, color: Colors.deepOrange),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.deepOrange),
                      enabledBorder: UnderlineInputBorder(      
                        borderSide: BorderSide(color: Colors.deepOrange),   
                      )
                    ),
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock, color: Colors.deepOrange),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.deepOrange),
                      enabledBorder: UnderlineInputBorder(      
                        borderSide: BorderSide(color: Colors.deepOrange),   
                      )
                    ),
                    obscureText: true,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
                  ),
                  Padding(
                    child:
                      RegisterButton(
                        onPressed: isRegisterButtonEnabled(state)
                        ? _onFormSubmitted
                        : null,               
                      ),
                    padding: EdgeInsets.only(top:15),
                  ),
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.dispatch(
      EmailChanged(email: emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.dispatch(
      PasswordChanged(password: passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.dispatch(
      Submitted(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
  }

}