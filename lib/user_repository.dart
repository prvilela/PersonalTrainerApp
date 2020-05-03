import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_bloc/facebook_login_button.dart';



class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FacebookLoginButtonState flbs = new FacebookLoginButtonState();

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin, name})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  //login google
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
}

  //login email comum
  Future<void> signInWithCredentials(String email, String password) async { 
      return _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );     
  }

  verificarConfirmar(String email, String password) async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user.isEmailVerified){
      signInWithCredentials(email, password);
    }
    else{
      print("Não verificou o email né tio!");
      // colocar sign out aqui, usuario n confirmou o email
    }  
  }

  //create account
  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  enviarEmail({String email, String password}) async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    try {
        await user.sendEmailVerification();
        return await user.uid;
     } catch (e) {
        print("An error occured while trying to send email verification");
        print(e.message);
     }
  }

  //logout
  Future<void> signOut() async {
    //flbs.logout();
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  //chech if already signed in
  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }
  

  Future<String>  get getUser async {
    return (await _firebaseAuth.currentUser()).email;
    
  }

   Future<void>  getUserInstance() async {
    return (await _firebaseAuth.currentUser());
  }

  Future<void> resetPassword(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
}


}
