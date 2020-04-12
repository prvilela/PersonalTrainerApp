import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_trainer/Widget/gym_tile.dart';

import 'package:personal_trainer/blocs/getPacotes_bloc.dart';

import '../blocs/getGym_bloc.dart';

class GymTab extends StatefulWidget {
  @override
  GymTabState createState() => GymTabState();
}

class GymTabState extends State<GymTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _gymBloc = BlocProvider.of<GetGymBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
        stream: _gymBloc.outGym,
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
              ),
            );
          }else if(snapshot.data.length == 0){
            return Center(
              child: Text("Nenhuma academia encontrada!",
                style: TextStyle(color: Colors.pinkAccent),
              ),
            );
          }else{
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return GymTile(snapshot.data[index]);
                }
            );
          }
        },
      ),
    );

    /*return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, AsyncSnapshot<FirebaseUser>snapshot1) {
        if(!snapshot1.hasData){
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
            ),
          );
        }else {
          return FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection("gym").where(
                "id", isEqualTo: snapshot1.data.uid).getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
                  ),
                );
              else
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return GymTile(snapshot.data.documents[index]);
                    }
                );
            },
          );
        }
      }
    );*/
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
