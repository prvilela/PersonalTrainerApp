import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_trainer/Widget/student_tile.dart';

class StudentTab extends StatefulWidget {
  @override
  _StudentTabState createState() => _StudentTabState();
}

class _StudentTabState extends State<StudentTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {

    super.build(context);

    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("student").getDocuments(),
      builder: (context,snapshot){
        if(!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
            ),
          );
        else
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
              return StudentTile(snapshot.data.documents[index]);
            }
          );
      },
    );
  }

  @override

  bool get wantKeepAlive => true;
}