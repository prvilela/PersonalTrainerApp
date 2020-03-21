import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AulaBloc extends BlocBase{

  final _createdController = BehaviorSubject<bool>();
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();

  Stream<bool> get outCreated => _createdController.stream;
  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;

  DocumentSnapshot aulas;

  Map<String, dynamic> unsavedData;

  AulaBloc(this.aulas){
    if(aulas!= null){
      unsavedData = Map.from(aulas.data);
      
      _createdController.add(true);
    }else{
      unsavedData = {
        "name":null,
        "cpf":null,
        "data":null,
        "hora":null,
        "academia":null,
        "duracao":null,
        "preco":null
      };
      _createdController.add(false);
    }
    _dataController.add(unsavedData);
  }

  void saveName(String text){
    unsavedData["name"] = text;
  }
  void saveCpf(String text){
    unsavedData["cpf"] = text;
  }
  void saveData(String text){
    unsavedData["data"] = text;
  }
  void saveHora(String text){
    unsavedData["hora"] = text;
  }
  void saveAcademia(String text){
    unsavedData["academia"] = text;
  }
  void saveDuracao(String text){
    unsavedData["duracao"] = text;
  }
  void savePreco(String text){
    unsavedData["preco"] = text;
  }
  void saveId(String text){
    unsavedData["id"] = text;
  }


  Future<bool> saveAula() async{
    _loadingController.add(true);
    try{
      if(aulas!=null){
        await aulas.reference.updateData(unsavedData);
      }else{
        DocumentReference dr = await Firestore.instance.collection("aulas").
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

  void deleteAula(){
    aulas.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _createdController.close();
    _loadingController.close();
  }

}