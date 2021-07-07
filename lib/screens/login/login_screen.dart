//import 'package:apppersonaltrainer/common/custom_drawer/divider_line.dart';
import 'package:apppersonaltrainer/helpers/validators.dart';
//import 'package:apppersonaltrainer/models/facebook_sign.dart';
import 'package:apppersonaltrainer/models/user.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void sign() async{
  try{
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
    );
    final AuthResult authResult =
      await FirebaseAuth.instance.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
  }catch (error){

  }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Entrar"),
        centerTitle: true,
      ),
      body: Card(
        margin: EdgeInsets.fromLTRB(16, 30, 16, 45),
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
                    decoration: const InputDecoration(hintText: 'E-mail'),
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
                    decoration: const InputDecoration(hintText: 'Senha'),
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
                 Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Não tem cadastro?'),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/signup');
                          },
                          padding: EdgeInsets.zero,
                          child: const Text('Clique Aqui!', style: TextStyle(color: Colors.orange),))
                    ],
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
    );
  }
}
