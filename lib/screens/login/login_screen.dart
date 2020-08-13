import 'package:apppersonaltrainer/helpers/validators.dart';
import 'package:apppersonaltrainer/models/user.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:apppersonaltrainer/screens/base/base_screen.dart';
import 'package:apppersonaltrainer/google_auth/sign_in.dart';
import 'package:apppersonaltrainer/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/signup');
              },
              child: const Text(
                "CRIAR CONTA",
                style: TextStyle(fontSize: 14),
              ),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Entre com sua conta!',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            Center(
              child: Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 42),
                child: Form(
                  key: formKey,
                  child: Consumer<UserManager>(
                    builder: (_, userManager, child) {
                      return ListView(
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true,
                        children: <Widget>[
                          TextFormField(
                            enabled: !userManager.loading,
                            controller: emailController,
                            decoration:
                                const InputDecoration(hintText: 'E-mail'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            validator: (email) {
                              if (!emailValid(email)) {
                                return 'E-mail inválido';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            enabled: !userManager.loading,
                            controller: passController,
                            decoration:
                                const InputDecoration(hintText: 'Senha'),
                            autocorrect: false,
                            obscureText: true,
                            validator: (pass) {
                              if (pass.isEmpty || pass.length < 6) {
                                return 'Senha inválida';
                              }

                              return null;
                            },
                          ),
                          child,
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 44,
                            child: RaisedButton(
                              onPressed: userManager.loading
                                  ? null
                                  : () {
                                      if (formKey.currentState.validate()) {
                                        userManager.signIn(
                                            user: User(
                                                email: emailController.text,
                                                password: passController.text),
                                            onFail: (e) {
                                              scaffoldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                content:
                                                    Text('Falha ao entrar: $e'),
                                                backgroundColor: Colors.red,
                                              ));
                                            },
                                            onSuccess: () {
                                              Navigator.of(context).pop();
                                            });
                                      }
                                    },
                              color: Theme.of(context).primaryColor,
                              disabledColor:
                                  Theme.of(context).primaryColor.withAlpha(100),
                              textColor: Colors.white,
                              child: userManager.loading
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    )
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(fontSize: 18),
                                    ),
                            ),
                          ),
                        ],
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          child: const Text('Esqueci minha senha')),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    onPressed: () {
                      signInWithGoogle().whenComplete(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return BaseScreen();
                            },
                          ),
                        );
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    color: Colors.white,
                    child: Image(
                      image: AssetImage("images/google_logo.png"),
                      height: 35.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    color: Colors.white,
                    child: Image(
                      image: AssetImage("images/face_logo2.png"),
                      height: 35.0,
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
