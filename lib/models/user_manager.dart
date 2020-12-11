import 'package:apppersonaltrainer/helpers/firebase_errors.dart';
import 'package:apppersonaltrainer/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
      id: user.uid,
      email: user.email,
      name: user.displayName,
    );
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  var facebookLogin = new FacebookLogin();
  final Firestore firestore = Firestore.instance;

  StreamSubscription _subscription;

  User user;

  bool _loading = false;
  bool get loading => _loading;
  bool get isloggedIn => user != null;

  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult authResult = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      await _loadCurrentUser(firebaseUser: authResult.user);

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if (currentUser != null) {
      _subscription = firestore
          .collection('users')
          .document(currentUser.uid)
          .snapshots()
          .listen((event) {
        user = User.fromDocument(event);
        final date = DateTime.now();
        if (user.atualizado == 1) {
          if (date.day == 1) {
            user.pagamentos = [0];
            user.atualizado = 0;
            user.saveData();
          }
        } else {
          if (date.day == 2) {
            user.atualizado = 1;
            user.saveData();
          }
        }
        notifyListeners();
      });
    }
  }

  Future<void> signUp({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult authResult = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      user.pagamentos = [0];
      user.atualizado = 1;
      user.id = authResult.user.uid;
      this.user = user;
      await user.saveData();

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  //google
  Future<User> signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final authResult = await auth.signInWithCredential(credential);
    print(authResult);
    user = _userFromFirebase(authResult.user);
    notifyListeners();
    return _userFromFirebase(authResult.user);
  }

  void signOutGoogle() async {
    return auth.signOut();
    user = null;
    notifyListeners();
  }

  Future<User> currentUser() async {
    final user = await auth.currentUser();
    return _userFromFirebase(user);
  }

  //facebook
  Future<User> loginWithFacebook() async {
    final facebookLogin = new FacebookLogin();
    final FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(['email', 'public_profile']);

    FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;
    AuthCredential authCredential = FacebookAuthProvider.getCredential(
        accessToken: facebookAccessToken.token);
    FirebaseUser fbUser;
    fbUser = (await auth.signInWithCredential(authCredential)).user;
    user = _userFromFirebase(fbUser);
    notifyListeners();
    return _userFromFirebase(fbUser);
  }

  void facebookLogout() {
    facebookLogin.logOut();
    FirebaseAuth.instance.signOut();
  }
}
