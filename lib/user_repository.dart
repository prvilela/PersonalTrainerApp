import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

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

  verificarConfirmar({String email, String password}) async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user.isEmailVerified){
    }
    else{
      print("Não verificou o email né tio!");
      signOut();
      // colocar sign out aqui, usuario n confirmou o email
    }  
  }

  //create account
  //falta verificar se confirmou email e adcioanar um label pra mandar o usuario confirmar o email
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

  //Future<void> sendEmailVerification() async {
    //FirebaseUser user = await _firebaseAuth.currentUser();
    //user.sendEmailVerification();
  //}

  /*Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user.isEmailVerified == true){
      return true;
    } 
    else{
      return false;
    }      
  }*/


  //Future<void> confirmarEmail() async {
    //final currentUser = await _firebaseAuth.currentUser();
    //print(currentUser);
    //currentUser.sendEmailVerification(); 
    //print("aeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee keaioooooooooooooooooooooooo");
    
  //}

  //logout
  Future<void> signOut() async {
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
