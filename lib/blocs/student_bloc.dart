import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentBloc extends BlocBase{

  final _createdController = BehaviorSubject<bool>();
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();

  Stream<bool> get outCreated => _createdController.stream;
  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;

  DocumentSnapshot student;

  Map<String, dynamic> unsavedData;
  Map<String, dynamic> compra;

  StudentBloc(this.student){
    if(student!= null){
      unsavedData = Map.from(student.data);
      
      _createdController.add(true);
    }else{
      unsavedData = {
        "name":"",
        "birthday":"",
        "gender":"",
        "cpf":"",
        "email":"",
        "phone":"",
        "goal":"",
        "restrictions":"",
        "status":"",
        "id":"",
        "gym":"",
        "plano":"",
        "hora":"",
        "dataInicio": null,
        "dataCobranca":null,
        "quantidade":null,
        "days":{
          "segunda": false,
          "terca"  : false,
          "quarta" : false,
          "quinta" : false,
          "sexta"  : false,
          "sabado" : false,
          "domingo": false
        },

      };
      _createdController.add(false);
    }
    _dataController.add(unsavedData);

  }

  void saveName(String text){
    unsavedData["name"] = text;
  }
  void saveBirthday(String text){
    unsavedData["birthday"] = text;
  }
  void saveGender(String text){
    unsavedData["gender"] = text;
  }
  void saveCpf(String text){
    unsavedData["cpf"] = text;
  }
  void saveEmail(String text){
    unsavedData["email"] = text;
  }
  void savePhone(String text){
    unsavedData["phone"] = text;
  }
  void saveGoal(String text){
    unsavedData["goal"] = text;
  }
  void saveRestrictions(String text){
    unsavedData["restrictions"] = text;
  }
  void saveId(String text){
    unsavedData["id"] = text;
  }
  void saveStatus(String text){
    unsavedData["status"] = text;
    if(text == "Ativo" && unsavedData["dataInicio"] == null){
      saveData();
    }else if(text == "Não Ativo"){
      unsavedData["dataInicio"] = null;
      unsavedData["dataCobranca"] = null;
    }
  }

  void saveQuanti(String text){
    unsavedData["quantidade"] = text;
  }

  void saveGym(String text){
    unsavedData["gym"] = text;
  }
  void savePlano(String text){
    unsavedData["plano"] = text;
  }
  void saveDays(Map<String, bool> text){
    unsavedData["days"] = text;
  }

  void saveHora(String text){
    unsavedData["hora"] = text;
  }

  void saveData(){
    var now = new DateTime.now();
    var cobranca = now.add(new Duration(days: 30));
    unsavedData["dataInicio"] = now.toString();
    unsavedData["dataCobranca"] = cobranca.toString();
  }

  Future<bool> saveStudent() async{
    _loadingController.add(true);

    try{
      if(student!=null){
        await student.reference.updateData(unsavedData);
      }else{
        DocumentReference dr = await Firestore.instance.collection("student").
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
    student.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _createdController.close();
    _loadingController.close();
  }
}