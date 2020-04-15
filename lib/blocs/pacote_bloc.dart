import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacoteBloc extends BlocBase{

  final _createdController = BehaviorSubject<bool>();
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();

  Stream<bool> get outCreated => _createdController.stream;
  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;

  DocumentSnapshot pacote;

  Map<String, dynamic> unsavedData;

  PacoteBloc(this.pacote){
    if(pacote!= null){
      unsavedData = Map.from(pacote.data);

      _createdController.add(true);
    }else{
      unsavedData = {
        "idPersonal":null,
        "type":null,
        "price":null,
        "duration":null,
        "quantidade": null,
      };
      _createdController.add(false);
    }
    _dataController.add(unsavedData);
  }

  void saveId(String text){
    unsavedData["idPersonal"] = text;
  }
  void saveType (String text){
    unsavedData["type"] = text;
  }
  void savePrice(String text){
    unsavedData["price"] = text;
  }

  void saveDuration(String text){
    unsavedData["duration"] = text;
  }

  void saveQuantidade(String text){
    unsavedData["quantidade"] = text;
  }


  Future<bool> savePacote() async{
    _loadingController.add(true);

    try{
      if(pacote!=null){
        await pacote.reference.updateData(unsavedData);
      }else{
        DocumentReference dr = await Firestore.instance.collection("pacote").
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

  void deleteStudent(){
    pacote.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _createdController.close();
    _loadingController.close();
  }

}