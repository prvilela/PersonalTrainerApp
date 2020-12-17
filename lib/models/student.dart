import 'package:apppersonaltrainer/models/student_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'agendamento.dart';

class Student extends ChangeNotifier {
  Student(
      {this.id,
      this.idPersonal,
      this.name,
      this.birthday,
      this.gender,
      this.cpf,
      this.email,
      this.phone,
      this.goal,
      this.restriction,
      this.status,
      this.gym,
      this.plano,
      this.mesIni,
      this.quant,
      this.days,
      this.quantityMonths}) {
    if (this.days == null) {
      this.days = Agendamento();
    }
    if (this.gender == null) {
      this.gender = 'Masculino';
    }
    if (this.status == null) {
      this.status = 'Ativo';
    }
  }

  Student.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    idPersonal = snapshot['idPersonal'] as String;
    name = snapshot['name'] as String;
    birthday = snapshot['birthday'] as String;
    gender = snapshot['gender'] as String;
    cpf = snapshot['cpf'] as String;
    email = snapshot['email'] as String;
    phone = snapshot['phone'] as String;
    goal = snapshot['goal'] as String;
    restriction = snapshot['restriction'] as String;
    status = snapshot['status'] as String;
    gym = snapshot['gym'] as String;
    plano = snapshot['plano'] as String;
    mesIni = snapshot['mesIni'] as int;
    quant = snapshot['quant'] as int;
    quantityMonths = snapshot['quantityMonths'] as int;
    days = Agendamento.fromMap(snapshot['days'] as Map<String, dynamic>);
  }

  String id;
  String idPersonal;
  String name;
  String birthday;
  String gender;
  String cpf;
  String email;
  String phone;
  String goal;
  String restriction;
  String status;
  String gym;
  String plano;
  int mesIni;
  int quant;
  int quantityMonths;
  Agendamento days = Agendamento();

  String hora;
  List dias;

  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef => firestore.document('student/$id');

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Agendamento _selectedDay;

  Agendamento get selectedDay => _selectedDay;

  set selectedDay(Agendamento value) {
    _selectedDay = value;
    notifyListeners();
  }

  Student clone() {
    return Student(
        id: id,
        email: email,
        days: days,
        birthday: birthday,
        cpf: cpf,
        mesIni: mesIni,
        gender: gender,
        goal: goal,
        gym: gym,
        idPersonal: idPersonal,
        name: name,
        phone: phone,
        plano: plano,
        quant: quant,
        quantityMonths: quantityMonths,
        restriction: restriction,
        status: status);
  }

  void updateGender(String sexo) {
    if (sexo.contains('Mas')) {
      gender = 'Masculino';
      notifyListeners();
    } else if (sexo.contains('Fem')) {
      gender = 'Feminino';
      notifyListeners();
    } else {
      gender = 'Outro';
      notifyListeners();
    }
  }

  void updateTime(TimeOfDay time) {
    time = time;
    hora = time.toString();
    notifyListeners();
    //chechHorario();
  }

  void updateStatus(String ativo) {
    if (ativo == 'Ativo') {
      status = 'Ativo';
      notifyListeners();
    } else {
      status = 'Não Ativo';
      notifyListeners();
    }
  }

  void updateDays(String ativo) {
    switch (ativo) {
      case 'Dom':
        days.dom = !days.dom;
        break;
      case 'Seg':
        days.seg = !days.seg;
        break;
      case 'Ter':
        days.ter = !days.ter;
        break;
      case 'Quar':
        days.quar = !days.quar;
        break;
      case 'Quin':
        days.quin = !days.quin;
        break;
      case 'Sex':
        days.sex = !days.sex;
        break;
      case 'Sab':
        days.sab = !days.sab;
        break;
    }
    dias = [
      days.dom,
      days.seg,
      days.ter,
      days.quar,
      days.quin,
      days.sex,
      days.sab
    ];
    notifyListeners();
    //chechHorario();
  }

  void save() async {
    final Map<String, dynamic> data = {
      'email': email,
      'days': days.toMap(),
      'birthday': birthday,
      'cpf': cpf,
      'mesIni': mesIni ?? DateTime.now().month,
      'gender': gender,
      'goal': goal,
      'gym': gym,
      'idPersonal': idPersonal,
      'name': name,
      'phone': phone,
      'plano': plano,
      'quant': quant ?? 0,
      'quantityMonths': quantityMonths,
      'restriction': restriction,
      'status': status
    };

    if (id == null) {
      final doc = await firestore.collection('student').add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }
  }

  void remove() {
    firestoreRef.delete();
  }

  void checkHorario() {}

}
