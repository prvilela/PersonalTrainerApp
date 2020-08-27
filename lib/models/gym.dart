import 'package:apppersonaltrainer/services/cepaberto_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Gym extends ChangeNotifier{

  Gym({this.id, this.name, this.idPersonal, this.location, this.phone, this.rua,
      this.price});

  Gym.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    idPersonal = snapshot['idPersonal'] as String;
    name = snapshot['name'] as String;
    location = snapshot['location'] as String;
    phone = snapshot['phone'] as String;
    rua = snapshot['rua'] as String;
    price = snapshot['price'] as num;
  }

  String id;
  String name;
  String idPersonal;
  String location;
  String phone;
  String rua;
  num price;

  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef => firestore.document('gym/$id');

  Gym clone(){
    return Gym(
      idPersonal: idPersonal,
      name: name,
      price: price,
      phone: phone,
      location: location,
      rua: rua
    );
  }

  void save()async{

    final Map<String,dynamic> data = {
      'idPersonal': idPersonal,
      'name': name,
      'price': price,
      'phone': phone,
      'location': location,
      'rua': rua,
    };

    if(id == null){
      final doc = await firestore.collection('gym').add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }

  }

  void remove(){
    firestoreRef.delete();
  }

  Future<String> getAddress(String cep)async{
    final cepAbertoService = CepAbertoService();

    try{
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      if(cepAbertoAddress != null){
        return cepAbertoAddress.rua+' - '+cepAbertoAddress.bairro;
      }

    }catch(e){
      debugPrint(e.toString());
    }

  }

}