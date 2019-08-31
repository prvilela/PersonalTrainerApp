import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_trainer/Widget/gym_tile.dart';

class GymTab extends StatefulWidget {
  @override
  _GymTabState createState() => _GymTabState();
}

class _GymTabState extends State<GymTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {

    super.build(context);

    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("gym").getDocuments(),
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
              return GymTile(snapshot.data.documents[index]);
            }
          );
      },
    );
  }

  @override

  bool get wantKeepAlive => true;
}
