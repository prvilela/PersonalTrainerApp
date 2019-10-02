import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_trainer/blocs/bloc.dart';
import 'package:personal_trainer/login_bloc/facebook_login_button.dart';
import 'package:personal_trainer/user_repository.dart';
import 'package:personal_trainer/login_bloc/bloc.dart';
import 'package:personal_trainer/login_bloc/login_bloc.dart';
import 'package:personal_trainer/login_bloc/google_login_button.dart';
import 'package:personal_trainer/login_bloc/create_account_button.dart';
import 'package:personal_trainer/login_bloc/login_button.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  UserRepository u1 = new UserRepository();
  String textoTf;

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _loginBloc,
      listener: (BuildContext context, LoginState state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Login Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.black,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
        }
      },
      child: BlocBuilder(
        bloc: _loginBloc,
        builder: (BuildContext context, LoginState state) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset('assets/logotipo.png', height: 100),
                  ),
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white, fontSize: 18), 
                    decoration: InputDecoration(
                      icon: Icon(Icons.email, color: Colors.white),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.white), 
                      enabledBorder: UnderlineInputBorder( 
                        borderSide: BorderSide(color: Colors.white),   
                      )
                    ),
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.white, fontSize: 18), 
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock,color: Colors.white),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white), 
                      enabledBorder: UnderlineInputBorder(      
                        borderSide: BorderSide(color: Colors.white),   
                      ),
                      suffixIcon: IconButton(
                      icon: Icon(Icons.help, color: Colors.white),
                      //passar email que foi esquecido a senha (para tela UserRepository)
                      onPressed: () {
                        if(_emailController.text.isEmpty){
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [Text('Digite seu email!'),],
                              ),
                            ),
                          );
                        }
                        //if(u1.resetPassword(textoTf) == null){
                          //print("Email não cadastrado!");
                        //}
                        else{
                          textoTf = _emailController.text;
                          u1.resetPassword(textoTf);
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [Text('Email enviado para: '+"$textoTf"),],
                              ),
                            ),
                          );                          
                        }
                      })
                    ),
                    obscureText: true,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LoginButton(
                          onPressed: isLoginButtonEnabled(state)
                              ? _onFormSubmitted
                              : null,
                        ),
                        GoogleLoginButton(),

                        FacebookLoginButton(),
                    
                        CreateAccountButton(userRepository: _userRepository),            
                      ],
                    ),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.dispatch(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.dispatch(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
  
}