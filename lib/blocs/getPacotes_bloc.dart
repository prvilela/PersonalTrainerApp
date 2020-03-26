import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

enum SortCriterioPacotes {ORDERGYM, ORDERATIV}

class GetPacotesBloc extends BlocBase{

  final _getPacotesController = BehaviorSubject<List>();

  Stream<List> get outPacotes => _getPacotesController.stream;

  Firestore _firestore = Firestore.instance;

  List<DocumentSnapshot> _gym = [];

  SortCriterioPacotes _criteria;

  GetPacotesBloc() : super(){
    _addGymListener();
  }

  void _addGymListener() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String sid = user.uid;
    _firestore.collection("pacote").where("idPersonal", isEqualTo: sid).
    snapshots().listen((snapshot){
      snapshot.documentChanges.forEach((change){
        String sid = change.document.documentID;
        switch(change.type){
          case DocumentChangeType.added:
            _gym.add(change.document);
            break;
          case DocumentChangeType.modified:
            _gym.removeWhere((gym)=> gym.documentID == sid);
            _gym.add(change.document);
            break;
          case DocumentChangeType.removed:
            _gym.removeWhere((gym)=> gym.documentID == sid);
            break;
        }
      });
      _getPacotesController.add(_gym);
    });
  }
/*
  void setGymCriteria(SortCriterioPacotes criteria){

    _criteria = criteria;
    _sort();
  }

  void _sort(){
    switch(_criteria){

      case SortCriterioPacotes.ORDERGYM:
        _gym.sort((a,b){
          List<String> c = [a.data["name"],b.data["name"]];

          c.sort();

          if(c[0] == b.data["name"]) return 1;
          else return -1;
        });
        break;

      case SortCriterioPacotes.ORDERATIV:
        _gym.sort((a,b){
          String sa = a.data["status"];
          int c;
          String sb = b.data["status"];
          int d;

          if(sa == "Ativo") c=1;
          else c=2;
          if(sb == "Ativo") d=1;
          else d=2;
          if(c>d) return 1;
          else if(c<d) return -1;
          else return 0;
        });
        break;
    }

  }*/

  @override
  void dispose() {
    _getPacotesController.close();
  }
}