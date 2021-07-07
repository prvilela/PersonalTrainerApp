import 'dart:async';

import 'package:apppersonaltrainer/models/student.dart';
import 'package:apppersonaltrainer/models/user.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class StudentManager extends ChangeNotifier {
  StudentManager() {
    loadAllStudents();
  }

  void updateStudent(UserManager userManager) {
    usuario = userManager.user;
    _subscription?.cancel();
    _allStudent?.clear();
    loadAllStudents();
  }

  StreamSubscription _subscription;

  final Firestore firestore = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;

  User usuario;

  List<Student> _allStudent;

  String _search = '';
  String _filter = '';

  List<Student> get students => _allStudent;

  String get filter => _filter;
  set filter(String value) {
    _filter = value;
    notifyListeners();
  }

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Student> filteredStudentByMonth(int mes) {
    final List<Student> filteredStudentByMonth = [];

    filteredStudentByMonth.addAll(
        _allStudent.where((s) => s.idPersonal == user?.uid && s.mesIni == mes));

    return filteredStudentByMonth;
  }

  List<Student> filteredStudentByWeekday(int day) {
    final List<Student> filteredStudent = [];
    switch (day) {
      case 1:
        filteredStudent.addAll(
            _allStudent.where((s) => s.days.seg && s.idPersonal == user.uid));
        filteredStudent.sort((a, b) {
          //List<String> c = [a.days.horarioSeg, b.days.horarioSeg];
          //c.sort();
          List<String> primeiro = a.days.horarioSeg.split(":");
          List<String> segundo = b.days.horarioSeg.split(":");
          if (int.parse(primeiro[0]) < int.parse(segundo[0]) ||
              (int.parse(primeiro[0]) == int.parse(segundo[0]) && int.parse(primeiro[1]) < int.parse(segundo[1])))
            return -1;
          else
            return 1;
        });
        break;
      case 2:
        filteredStudent.addAll(
            _allStudent.where((s) => s.days.ter && s.idPersonal == user.uid));
        filteredStudent.sort((a, b) {
          List<String> primeiro = a.days.horarioTer.split(":");
          List<String> segundo = b.days.horarioTer.split(":");
          if (int.parse(primeiro[0]) < int.parse(segundo[0]) ||
              (int.parse(primeiro[0]) == int.parse(segundo[0]) && int.parse(primeiro[1]) < int.parse(segundo[1])))
            return -1;
          else
            return 1;
        });
        break;
      case 3:
        filteredStudent.addAll(
            _allStudent.where((s) => s.days.quar && s.idPersonal == user.uid));
        filteredStudent.sort((a, b) {
          List<String> primeiro = a.days.horarioQuar.split(":");
          List<String> segundo = b.days.horarioQuar.split(":");
          if (int.parse(primeiro[0]) < int.parse(segundo[0]) ||
              (int.parse(primeiro[0]) == int.parse(segundo[0]) && int.parse(primeiro[1]) < int.parse(segundo[1])))
            return -1;
          else
            return 1;
        });
        break;
      case 4:
        filteredStudent.addAll(
            _allStudent.where((s) => s.days.quin && s.idPersonal == user.uid));
        filteredStudent.sort((a, b) {
          List<String> primeiro = a.days.horarioQuin.split(":");
          List<String> segundo = b.days.horarioQuin.split(":");
          if (int.parse(primeiro[0]) < int.parse(segundo[0]) ||
              (int.parse(primeiro[0]) == int.parse(segundo[0]) && int.parse(primeiro[1]) < int.parse(segundo[1])))
            return -1;
          else
            return 1;
        });
        break;
      case 5:
        filteredStudent.addAll(
            _allStudent.where((s) => s.days.sex && s.idPersonal == user.uid));
        filteredStudent.sort((a, b) {
          List<String> primeiro = a.days.horarioSex.split(":");
          List<String> segundo = b.days.horarioSex.split(":");
          if (int.parse(primeiro[0]) < int.parse(segundo[0]) ||
              (int.parse(primeiro[0]) == int.parse(segundo[0]) && int.parse(primeiro[1]) < int.parse(segundo[1])))
            return -1;
          else
            return 1;
        });
        break;
      case 6:
        filteredStudent.addAll(
            _allStudent.where((s) => s.days.sab && s.idPersonal == user.uid));
        filteredStudent.sort((a, b) {
          List<String> primeiro = a.days.horarioSab.split(":");
          List<String> segundo = b.days.horarioSab.split(":");
          if (int.parse(primeiro[0]) < int.parse(segundo[0]) ||
              (int.parse(primeiro[0]) == int.parse(segundo[0]) && int.parse(primeiro[1]) < int.parse(segundo[1])))
            return -1;
          else
            return 1;
        });
        break;
      case 7:
        filteredStudent.addAll(
            _allStudent.where((s) => s.days.dom && s.idPersonal == user.uid));
        filteredStudent.sort((a, b) {
          List<String> primeiro = a.days.horarioDom.split(":");
          List<String> segundo = b.days.horarioDom.split(":");
          if (int.parse(primeiro[0]) < int.parse(segundo[0]) ||
              (int.parse(primeiro[0]) == int.parse(segundo[0]) && int.parse(primeiro[1]) < int.parse(segundo[1])))
            return -1;
          else
            return 1;
        });
        break;
      default:
    }


    return filteredStudent;
  }

  List<Student> get filteredStudent {
    final List<Student> aux = [];
    final List<Student> filteredStudent = [];

    final String palavra = 'Não Ativo';

    if (filter == 'Não Ativo') {
      aux.addAll(_allStudent.where((s) =>
          s.status.toLowerCase().contains(palavra.toLowerCase()) &&
          s.idPersonal == user.uid));
    } else if (filter == 'Ativo') {
      aux.addAll(_allStudent.where((s) =>
          !s.status.toLowerCase().contains(palavra.toLowerCase()) &&
          s.idPersonal == user.uid));
    } else {
      aux.addAll(_allStudent.where((s) => s.idPersonal == user?.uid));
    }

    if (search.isNotEmpty) {
      filteredStudent.addAll(aux
          .where((s) => s.name.toLowerCase().contains(search.toLowerCase())));
    } else {
      filteredStudent.addAll(aux);
    }

    return filteredStudent;
  }

  Future<void> loadAllStudents() async {
    user = await auth.currentUser();
    _subscription =
        firestore.collection('student').snapshots().listen((snapshot) {
      _allStudent =
          snapshot.documents.map((e) => Student.fromDocument(e)).toList();
      _allStudent
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  Student findStudentByID(String studentID) {
    try {
      return _allStudent.firstWhere((s) => s.id == studentID);
    } catch (e) {
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
