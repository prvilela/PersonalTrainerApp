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
  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //create account
  Future<void> signUp({String email, String password}) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )) as FirebaseUser;
    confirmarEmail(user); 
    return user;  
  }

  void confirmarEmail(user){
    user.sendEmailVerification(); 
    print("aeeeeeeeeeeeeeeeeeeeeeee keaioooooooooooooooooooooooo");
    print(user);
  }

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

  Future<void> resetPassword(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
}

}
