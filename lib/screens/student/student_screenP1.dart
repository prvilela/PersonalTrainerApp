import 'package:apppersonaltrainer/models/student.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StudentScreenP1 extends StatelessWidget {

  TimeOfDay _time = TimeOfDay.now().replacing(minute: 00);
  bool iosStyle = true;

  var horarioSeg = 'Selecione o horário';
  var horarioTer = 'Selecione o horário';
  var horarioQua = 'Selecione o horário';
  var horarioQui = 'Selecione o horário';
  var horarioSex = 'Selecione o horário';
  var horarioSab = 'Selecione o horário';
  var horarioDom = 'Selecione o horário';

  final Student student = Student();

  final plan = TextEditingController();
  final gym = TextEditingController();
  final donController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    void onTimeChanged(TimeOfDay newTime) {
      _time = newTime;
    }

    gym.text = student.gym;
    plan.text = student.plano;
    return ChangeNotifierProvider.value(
      value: student,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text( 'Criar Aluno'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        initialValue: student.name,
                        onSaved: (name) => student.name = name,
                        decoration: const InputDecoration(
                            hintText: 'Nome', border: InputBorder.none),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                        validator: (name) {
                          if (name.length < 6 && !name.contains(' ')) {
                            return 'Nome muito curto';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16,),
                      TextFormField(
                        initialValue: student.cpf,
                        onSaved: (text) => student.cpf = text,
                        decoration: const InputDecoration(
                            hintText: 'CPF', border: InputBorder.none),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          CpfInputFormatter()
                        ],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                        validator: (cpf) {
                          if (cpf.isEmpty) return 'Campo Obrigatório';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16,),
                      TextFormField(
                        initialValue: student.birthday,
                        onSaved: (text) => student.birthday = text,
                        decoration: const InputDecoration(
                            hintText: 'Data de nascimento',
                            border: InputBorder.none),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          DataInputFormatter()
                        ],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                        validator: (birthday) {
                          if (birthday.isEmpty) return 'Campo Obrigatório';
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<UserManager>(
                        builder: (_, user, __) {
                          return SizedBox(
                            height: 44,
                            child: RaisedButton(
                              onPressed: () async {
                                if (user.isloggedIn) {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();
                                    var voltar = await Navigator.of(context).pushNamed('/create_student_p2', arguments: student);
                                    if(voltar == 2){
                                      Navigator.of(context).pop(2);
                                    }                                  } else {
                                    scaffoldKey.currentState
                                        .showSnackBar(const SnackBar(
                                      content: const Text(
                                          'Existem campos vazios ou preenchidos incorretamente!'),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                } else {
                                  Navigator.of(context).pushNamed('/login');
                                }
                              },
                              textColor: Colors.white,
                              color: Theme.of(context).primaryColor,
                              disabledColor:
                              Theme.of(context).primaryColor.withAlpha(100),
                              child: Text(
                                user.isloggedIn
                                    ? 'Avançar'
                                    : 'Entre para Cadastrar',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
