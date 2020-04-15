import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/blocs/getStudent_bloc.dart';
import 'package:personal_trainer/calendar/calendar_main.dart';
import 'package:personal_trainer/home.dart';
import 'package:personal_trainer/tabs/pagamentos_tab.dart';
import 'package:personal_trainer/tiles/bottomNavigation.dart';

class Pagamento extends StatefulWidget {
  @override
  _PagamentoState createState() => _PagamentoState();
}

class _PagamentoState extends State<Pagamento> {
  BottomNavigationClass bn = new BottomNavigationClass();
  GetStudentBloc _getStudentBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStudentBloc = GetStudentBloc();
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    }

    return BlocProvider<GetStudentBloc>(
      bloc: _getStudentBloc,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Controle de Contas'),
          backgroundColor: Colors.deepOrange,
          actions: <Widget>[

          ],
        ),

        body: GestureDetector(
          onPanUpdate: (details){
            if (details.delta.dx < 0){
            print("Esquerda vai para tela da direita");
            }
            if (details.delta.dx > 0){
            print("Direita vai para tela da esquerda");
            //aqui oh
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => TelaPrincipal()),
            );
            }
            },

          child:PagamentosTab()
            ,
        ),
        bottomNavigationBar: bn,
      ),
    );
  }
}



