import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthService {
  final FacebookLogin facebookSignIn = new FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Fazer Stream Builder para verificar status atual do login do ususario
  Future signInwithFacebook() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    if (result.status == FacebookLoginStatus.loggedIn) {
      FacebookAccessToken accessToken = result.accessToken;
      final facebookAuthCred =
          FacebookAuthProvider.getCredential(accessToken: accessToken.token);
      await _auth.signInWithCredential(facebookAuthCred);
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    facebookSignIn.logOut();
  }
}
