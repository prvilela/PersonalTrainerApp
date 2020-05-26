import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GymBloc extends BlocBase{

  final _createdController = BehaviorSubject<bool>();
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();

  Stream<bool> get outCreated => _createdController.stream;
  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;

  DocumentSnapshot gym;

  Map<String, dynamic> unsavedData;

  GymBloc(this.gym){
    if(gym!= null){
      unsavedData = Map.from(gym.data);
      
      _createdController.add(true);
    }else{
      unsavedData = {
        "name":null,
        "location":null,
        "rua": null,
        "phone":null,
        "preco":null,
        "horarioSemanaA":null,
        "horarioSemanaF":null,
        "horarioSabadoA":null,
        "horarioSabadoF":null,
        "horarioDomingoA":null,
        "horarioDomingoF":null,
      };
      _createdController.add(false);
    }
    _dataController.add(unsavedData);
  }

  void saveName(String text){
    unsavedData["name"] = text;
  }
  void saveLocation(String text){
    unsavedData["location"] = text;
  }
  void saveRua(String text){
    unsavedData["rua"] = text;
  }
  void savePhone(String text){
    unsavedData["phone"] = text;
  }
  void savePreco(String text){
    unsavedData["preco"] = text;
  }
  void saveId(String text){
    unsavedData["id"] = text;
  }

  //horarios range slider, sendo A para abertura e B para fechamento
  void saveHorarioSemanaA(String text){
    unsavedData["horarioSemanaA"] = text;
  }
  void saveHorarioSemanaF(String text){
    unsavedData["horarioSemanaF"] = text;
  }
  void saveHorarioSabadoA(String text){
    unsavedData["horarioSabadoA"] = text;
  }
  void saveHorarioSabadoF(String text){
    unsavedData["horarioSabadoF"] = text;
  }
  void saveHorarioDomingoA(String text){
    unsavedData["horarioDomingoA"] = text;
  }
  void saveHorarioDomingoF(String text){
    unsavedData["horarioDomingoF"] = text;
  }

  Future<bool> saveGym() async{
    _loadingController.add(true);

    try{
      if(gym!=null){
        await gym.reference.updateData(unsavedData);
      }else{
        DocumentReference dr = await Firestore.instance.collection("gym").
          add(Map.from(unsavedData));
        await dr.updateData(unsavedData);
      }
      _createdController.add(true);
      _loadingController.add(false);
      print(unsavedData);
      return true;
    }catch(e){
      _loadingController.add(false);
      return false;
    }
  }

  void deleteGym(){
    gym.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _createdController.close();
    _loadingController.close();
  }
}