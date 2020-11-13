import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier{

  User({this.id, this.name, this.email, this.password, this.coef, this.phone, this.day, this.pagamentos, this.atualizado});

  User.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'] as String;
    email = document.data['email'] as String;
    coef = document.data['coef'] as String;
    phone = document.data['phone'] as String;
    day = document.data['day'] as int;
    pagamentos = (document.data['pagamentos'] as List).map((e) => e as num).toList();
    atualizado = document.data['atualizado'] as int;
  }

  String id;
  String name;
  String email;
  String password;
  String coef;
  String phone;
  int day;
  List<num> pagamentos;
  int atualizado;

  String confirmPassword;

  DocumentReference get firestoreRef =>
      Firestore.instance.document('users/$id');

  Future<void> saveData()async{
    await firestoreRef.setData(toMap());
    notifyListeners();
  }

  Map<String, dynamic> toMap(){
    return {
      "name": name,
      "email": email,
      "coed": coef,
      "phone": phone,
      "day": day,
      "pagamentos": pagamentos ?? [0],
      "atualizado": atualizado ?? 0
    };
  }

}