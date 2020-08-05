import 'dart:async';

import 'package:apppersonaltrainer/models/plan.dart';
import 'package:apppersonaltrainer/models/user.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class PlanManager extends ChangeNotifier {
  StudentManager() {
    _loadAllPlan();
  }

  void updatePlan(UserManager userManager) {
    usuario = userManager.user;
    _subscription?.cancel();
    _allPlan?.clear();
    _loadAllPlan();
  }

  StreamSubscription _subscription;

  final Firestore firestore = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;

  User usuario;

  List<Plan> _allPlan;

  List<Plan> get plans => _allPlan;

  Future<void> _loadAllPlan() async {
    user = await auth.currentUser();

    _subscription = firestore.collection('plan').snapshots().listen((snapshot) {
      _allPlan = snapshot.documents.map((e) => Plan.fromDocument(e)).toList();
      _allPlan
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  Plan findStudentByID(String planID) {
    try {
      return _allPlan.firstWhere((g) => g.id == planID);
    } catch (e) {
      return null;
    }
  }

  List<Plan> get filteredPlan {
    final List<Plan> aux = [];

    aux.addAll(_allPlan.where((s) => s.idPersonal == user?.uid));

    return aux;
  }

  List<String> get names => filteredPlan.map((g) => g.name).toList();

  int quantity(String nome) {
    return filteredPlan
        .firstWhere((element) => element.name == nome)
        .quantityMonths;
  }

  num price(String nome) {
    return filteredPlan
        .firstWhere((element) => element.name == nome)
        .pricePerClass;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
