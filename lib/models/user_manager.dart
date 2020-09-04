import 'package:apppersonaltrainer/helpers/firebase_errors.dart';
import 'package:apppersonaltrainer/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class UserManager extends ChangeNotifier {
  UserManager() {
    loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
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

      await loadCurrentUser(firebaseUser: authResult.user);

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

  Future<void> loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    print('$currentUser topppppppppppppppppp');
    if (currentUser != null) {
      _subscription = firestore
          .collection('users')
          .document(currentUser.uid)
          .snapshots()
          .listen((event) {
        user = User.fromDocument(event);
        notifyListeners();
      });
    }
  }

  Future<void> signUp({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult authResult = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

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
}
