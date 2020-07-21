import 'package:apppersonaltrainer/common/custom_drawer/custom_drawer.dart';
import 'package:apppersonaltrainer/models/planManager.dart';
import 'package:apppersonaltrainer/models/student_manager.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:apppersonaltrainer/screens/pagamentos/components/pagamento_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PagamentosScreen extends StatelessWidget {

  final date = DateTime.now();

  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final _fieldStale = TextStyle(color: Theme.of(context).primaryColor, fontSize: 20);

    InputDecoration _buildDecoratiom(String label) {
      return InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none
      );
    }

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Pagamentos'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<UserManager>(
        builder: (_,userManager,__){
          int m = date.month;
          num total=0;
          for(num i in userManager.user.pagamentos){
            total+=i;
          }
          priceController.text = total.toStringAsFixed(2);
          if(date.day>= userManager.user.day-5 && date.day <= userManager.user.day+2){
            return Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                      child:TextFormField(
                        readOnly: true,
                        style: _fieldStale,
                        decoration: _buildDecoratiom("Recebido do mês:"),
                        controller: priceController,
                      ),
                    ),
                  ),
                ),
                Consumer2<StudentManager,PlanManager>(
                  builder: (_,studentManager,planManager,__){
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: studentManager.filteredStudentByMonth(m).length,
                      itemBuilder: (_,index){
                        num price = planManager.price(studentManager.filteredStudentByMonth(m)[index].plano);
                        return PagamentoTile(
                          student: studentManager.filteredStudentByMonth(m)[index],
                          month: m,
                          price: price,
                          user: userManager.user,
                        );
                      }
                    );
                  },
                ),
              ],
            );
          }else{
            return Container();
          }
        }
      ),
    );
  }
}
