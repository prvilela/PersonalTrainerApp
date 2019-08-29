import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalBloc extends BlocBase{

  final _createdController = BehaviorSubject<bool>();
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();

  Stream<bool> get outCreated => _createdController.stream;
  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;

  DocumentSnapshot personal;

  Map<String, dynamic> unsavedData;

  PersonalBloc(this.personal){
    if(personal!= null){
      unsavedData = Map.from(personal.data);
      
      _createdController.add(true);
    }else{
      unsavedData = {
        "email":null,
        "password":null,
      };
      _createdController.add(false);
    }
    _dataController.add(unsavedData);
  }

  void saveEmail(String text){
    unsavedData["email"] = text;
  }
  void savePassword(String text){
    unsavedData["password"] = text;
  }

  Future<bool> savePersonal() async{
    _loadingController.add(true);

    try{
      if(personal!=null){
        await personal.reference.updateData(unsavedData);
      }else{
        DocumentReference dr = await Firestore.instance.collection("personal").
          add(Map.from(unsavedData));
        await dr.updateData(unsavedData);
      }
      _createdController.add(true);
      _loadingController.add(false);
      return true;
    }catch(e){
      _loadingController.add(false);
      return false;
    }
  }

  void deletePersonal(){
    personal.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _createdController.close();
    _loadingController.close();
  }
}