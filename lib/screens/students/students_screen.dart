import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:apppersonaltrainer/common/custom_drawer/custom_drawer.dart';
import 'package:apppersonaltrainer/models/student_manager.dart';
import 'package:apppersonaltrainer/screens/students/components/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import 'components/student_tile.dart';

class StudentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<StudentManager>(
          builder: (_, studentManager,__){
            if(studentManager.search.isEmpty){
              return const Text('Alunos');
            }else{
              return LayoutBuilder(
                builder: (_, constrains){
                  return GestureDetector(
                    onTap: ()async{
                      final search = await showDialog(context: context,
                        builder:(_)=> SearchDialog(studentManager.search));
                      if(search != null){
                        studentManager.search = search;
                      }
                    },
                    child: Container(
                      width: constrains.biggest.width,
                      child: Text(
                        studentManager.search,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          Consumer<StudentManager>(
            builder: (_, studentManager, __){
              if(studentManager.search.isEmpty){
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(context: context,
                        builder: (_)=>SearchDialog(studentManager.search));
                    if(search!=null){
                      studentManager.search = search;
                    }
                  },
                );
              }else{
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    studentManager.search = '';
                  },
                );
              }
            },
          )
        ],
      ),
      body: Consumer<StudentManager>(
        builder: (_,studentManger,__){
          final filteredStudent = studentManger.filteredStudent;
          if(filteredStudent.isNotEmpty) {
            return AlphabetListScrollView(
              indexedHeight: (index) => 150,
              strList: studentManger.names,
              showPreview: true,
              itemBuilder: (_, index) {
                return StudentTile(filteredStudent[index]);
              },
            );
          }else{
            return Container();
          }
        },
      ),
      floatingActionButton: Consumer<StudentManager>(
        builder: (_,studentManager,__){
          return SpeedDial(
            child: Icon(Icons.view_list),
            backgroundColor: Colors.orange,
            elevation: 0,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.person_add),
                  backgroundColor: Theme.of(context).primaryColor,
                  label: "Adicionar um aluno",
                  labelStyle: TextStyle(fontSize: 14),
                  onTap: (){
                    Navigator.of(context).pushNamed('/create_student');
                  }
              ),
              SpeedDialChild(
                  child: Icon(Icons.person),
                  backgroundColor: Theme.of(context).primaryColor,
                  label: "Ativos",
                  labelStyle: TextStyle(fontSize: 14),
                  onTap: (){
                    studentManager.filter='Ativo';
                  }
              ),
              SpeedDialChild(
                  child: Icon(Icons.person_outline),
                  backgroundColor: Theme.of(context).primaryColor,
                  label: "Não Ativos",
                  labelStyle: TextStyle(fontSize: 14),
                  onTap: (){
                    studentManager.filter='Não Ativo';
                  }
              ),
              if(studentManager.filter.isNotEmpty)
                SpeedDialChild(
                    child: Icon(Icons.close),
                    backgroundColor: Theme.of(context).primaryColor,
                    label: "Tirar filtros",
                    labelStyle: TextStyle(fontSize: 14),
                    onTap: (){
                      studentManager.filter = '';
                    }
                ),
            ],
          );
        },
      ),
    );
  }
}
