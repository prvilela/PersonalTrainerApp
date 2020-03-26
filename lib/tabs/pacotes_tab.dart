import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/Widget/pacotes_tile.dart';
import 'package:personal_trainer/blocs/getPacotes_bloc.dart';

class PacotesTab extends StatefulWidget {
  @override
  _PacotesTabState createState() => _PacotesTabState();
}

class _PacotesTabState extends State<PacotesTab> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _pacotesBloc = BlocProvider.of<GetPacotesBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
        stream: _pacotesBloc.outPacotes,
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
              ),
            );
          }else if(snapshot.data.length == 0){
            return Center(
              child: Text("Nenhum pacote encontrado!",
                style: TextStyle(color: Colors.pinkAccent),
              ),
            );
          }else{
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return PacotesTile(snapshot.data[index]);
                }
            );
          }
        },
      ),
    );
  }

  @override

  bool get wantKeepAlive => true;
}
