import 'dart:async';

import 'package:apppersonaltrainer/models/student.dart';
import 'package:apppersonaltrainer/models/user.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class StudentManager extends ChangeNotifier{

  StudentManager(){
    _loadAllStudents();
  }

  void updateStudent(UserManager userManager){
    usuario = userManager.user;
    _subscription?.cancel();
    _allStudent?.clear();
    _loadAllStudents();
  }

  StreamSubscription _subscription;


  final Firestore firestore = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user ;

  User usuario;

  List<Student> _allStudent;

  String _search = '';
  String _filter = '';

  List<Student> get students => _allStudent;

  String get filter => _filter;
  set filter(String value){
    _filter = value;
    notifyListeners();
  }

  String get search => _search;
  set search(String value){
    _search = value;
    notifyListeners();
  }

  List<Student> filteredStudentByMonth(int mes){
    final List<Student> filteredStudentByMonth = [];

    filteredStudentByMonth.addAll(
        _allStudent.where((s) => s.idPersonal == user?.uid && s.mesIni == mes));

    return filteredStudentByMonth;
  }

  List<Student> get filteredStudent{
    final List<Student> aux =[];
    final List<Student> filteredStudent = [];

    final String palavra = 'Não Ativo';

    if(filter == 'Não Ativo'){
      aux.addAll(_allStudent.where(
              (s) => s.status.toLowerCase().contains(palavra.toLowerCase())
                  && s.idPersonal == user.uid
        )
      );
    }else if(filter == 'Ativo'){
      aux.addAll(_allStudent.where(
              (s) => !s.status.toLowerCase().contains(palavra.toLowerCase())
              && s.idPersonal == user.uid
        )
      );
    }else{
      aux.addAll(_allStudent.where((s) => s.idPersonal == user?.uid));
    }


    if(search.isNotEmpty){
      filteredStudent.addAll(
          aux.where(
                  (s) => s.name.toLowerCase().contains(search.toLowerCase())
          )
      );
    }else{
      filteredStudent.addAll(aux);
    }

    return filteredStudent;
  }

  Future<void> _loadAllStudents() async{

    user = await auth.currentUser();

    _subscription = firestore.collection('student').snapshots().listen((snapshot) {
      _allStudent = snapshot.documents.map(
              (e) => Student.fromDocument(e)).toList();
      _allStudent.sort((a,b)=>a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  Student findStudentByID(String studentID){
    try{
      return _allStudent.firstWhere((s) => s.id == studentID);
    }catch (e){
      return null;
    }
  }

  List<String> get names => filteredStudent.map((s) => s.name).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

}