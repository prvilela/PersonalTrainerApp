import 'dart:async';

import 'package:apppersonaltrainer/models/address.dart';
import 'package:apppersonaltrainer/models/gym.dart';
import 'package:apppersonaltrainer/models/user.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:apppersonaltrainer/services/cepaberto_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class GymManager extends ChangeNotifier{

  StudentManager(){
    _loadAllGym();
  }

  void updateGym(UserManager userManager){
    usuario = userManager.user;
    _subscription?.cancel();
    _allGym?.clear();
    _loadAllGym();
  }

  StreamSubscription _subscription;

  final Firestore firestore = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user ;

  User usuario;
  Address address;

  List<Gym> _allGym;

  List<Gym> get gyms => _allGym;


  Future<void> _loadAllGym() async{
    user = await auth.currentUser();

    _subscription = firestore.collection('gym').snapshots().listen((snapshot) {
      _allGym = snapshot.documents.map(
              (e) => Gym.fromDocument(e)).toList();
      _allGym.sort((a,b)=>a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  Gym findStudentByID(String gymID){
    try{
      return _allGym.firstWhere((g) => g.id == gymID);
    }catch (e){
      return null;
    }
  }

  List<Gym> get filteredGym{
    final List<Gym> aux =[];

    aux.addAll(_allGym.where((s) => s.idPersonal == user?.uid));

    return aux;
  }

  List<String> get names => filteredGym.map((g) => g.name).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }



}