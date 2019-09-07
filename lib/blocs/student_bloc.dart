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

  StudentBloc(this.student){
    if(student!= null){
      unsavedData = Map.from(student.data);
      
      _createdController.add(true);
    }else{
      unsavedData = {
        "name":null,
        "birthday":null,
        "cpf":null,
        "email":null,
        "goal":null,
        "phone":null,
        "restrictions":null
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