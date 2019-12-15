import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_trainer/Widget/student_tile.dart';
import 'package:personal_trainer/blocs/getStudent_bloc.dart';

class StudentTab extends StatefulWidget {
  @override
  _StudentTabState createState() => _StudentTabState();
}

class _StudentTabState extends State<StudentTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _studentBloc = BlocProvider.of<GetStudentBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
        stream: _studentBloc.outStudents,
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
              ),
            );
          }else if(snapshot.data.length == 0){
            return Center(
              child: Text("Nenhum aluno encontrado!",
                style: TextStyle(color: Colors.pinkAccent),
              ),
            );
          }else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return StudentTile(snapshot.data[index]);
              }
            );
          }
        },
      ),
    );
  }
       
        catchId(){
                  FutureBuilder(
                    future: FirebaseAuth.instance.currentUser(),
                      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                        if (snapshot.hasData) {          
                        String id = (snapshot.data.uid);
                        print(id); 
                        return Text("$id");                     
                        }                                          
                    }      
                  );
                  
                  }
                  

  @override

  bool get wantKeepAlive => true;
}