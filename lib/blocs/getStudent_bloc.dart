import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

enum SortCriteria {ORDERNAME,ORDERGYM,ORDERATIV}

class GetStudentBloc extends BlocBase{

  final _getStudentController = BehaviorSubject<List>();

  Stream<List> get outStudents => _getStudentController.stream;

  Firestore _firestore = Firestore.instance;

  List<DocumentSnapshot> _students = [];

  SortCriteria _criteria;

  GetStudentBloc() : super(){
    _addStudentListener();
  }

  void _addStudentListener() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String sid = user.uid;
    _firestore.collection("student").where("id", isEqualTo: sid).
    snapshots().listen((snapshot){
      snapshot.documentChanges.forEach((change){
        String sid = change.document.documentID;
        switch(change.type){
          case DocumentChangeType.added:
            _students.add(change.document);
            break;
          case DocumentChangeType.modified:
            _students.removeWhere((student)=> student.documentID == sid);
            _students.add(change.document);
            break;
          case DocumentChangeType.removed:
            _students.removeWhere((student)=> student.documentID == sid);
            break;
        }
      });
      _sort();
    });
  }

  void setStudentCriteria(SortCriteria criteria){
    _criteria =criteria;
    _sort();
  }

  void _sort(){
    switch(_criteria){

      case SortCriteria.ORDERNAME:
        _students.sort((a,b){
          List<String> c = [a.data["name"],b.data["name"]];

          c.sort();

          if(c[0] == b.data["name"]) return 1;
          else return -1;
        });
        break;
      case SortCriteria.ORDERGYM:
        _students.sort((a,b){
          List<String> c = [a.data["gym"],b.data["gym"]];

          c.sort();

          if(c[0] == b.data["gym"]) return 1;
          else return -1;
        });
        break;
      case SortCriteria.ORDERATIV:
        _students.sort((a,b){
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
    _getStudentController.add(_students);
  }

  @override
  void dispose() {
    _getStudentController.close();
  }
}