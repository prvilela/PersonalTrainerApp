import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:personal_trainer/home.dart';

class FacebookLoginButton extends StatefulWidget {
  @override
  FacebookLoginButtonState createState() => FacebookLoginButtonState();
}

class FacebookLoginButtonState extends State<FacebookLoginButton> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoggedIn = false;
  var facebookLogin = FacebookLogin();
  FirebaseUser myUser;

  String _message;

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      icon: Icon(FontAwesomeIcons.facebookF, color: Colors.white),
      onPressed: () {
        initiateFacebookLogin(); 
      },
      label: Text('Sign in with Facebook', style: TextStyle(color: Colors.white)),
      color: Colors.blue,
    );
  }

void 
initiateFacebookLogin() async {
    var facebookLoginResult = await facebookLogin.logInWithReadPermissions(['email']);
     switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        onLoginStatusChanged(true);
        final credential = FacebookAuthProvider.getCredential(
        accessToken: facebookLoginResult.accessToken.token,
        );
        final user = (await _auth.signInWithCredential(credential)).user;
        _message = "Logged in as ${user.displayName}";

        trocarTela();
        break;
    }
  }

  logout() async {
    await facebookLogin.logOut();
    //_auth.signOut();
    print("Logged out from Facebook!");
    //trocarTela();
  }

  trocarTela(){
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaPrincipal()),
   );
  }

}