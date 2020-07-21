import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Plan extends ChangeNotifier{

  Plan({this.id, this.name, this.idPersonal, this.quantityMonths,
      this.pricePerClass, this.duration});

  Plan.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    idPersonal = snapshot['idPersonal'] as String;
    name = snapshot['name'] as String;
    quantityMonths = snapshot['quantityMonths'] as int;
    duration = snapshot['duration'] as int;
    pricePerClass = snapshot['pricePerClass'] as num;
  }

  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef => firestore.document('plan/$id');

  String id;
  String name;
  String idPersonal;
  int quantityMonths;
  num pricePerClass;
  int duration;

  Plan clone(){
    return Plan(
      idPersonal: idPersonal,
      name: name,
      quantityMonths: quantityMonths,
      duration: duration,
      pricePerClass: pricePerClass
    );
  }

  void save()async{

    final Map<String,dynamic> data = {
      'idPersonal': idPersonal,
      'name': name,
      'quantityMonths':quantityMonths,
      'duration': duration,
      'pricePerClass': pricePerClass,
    };

    if(id == null){
      final doc = await firestore.collection('plan').add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }

  }

  void remove(){
    firestoreRef.delete();
  }

  @override
  String toString() {
    return 'Plan{id: $id, name: $name, idPersonal: $idPersonal, quantityMonths: $quantityMonths}';
  }


}