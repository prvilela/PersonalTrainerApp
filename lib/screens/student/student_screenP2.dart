import 'package:apppersonaltrainer/common/custom_radio_button.dart';
import 'package:apppersonaltrainer/helpers/validators.dart';
import 'package:apppersonaltrainer/models/student.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StudentScreenP2 extends StatelessWidget {

  StudentScreenP2(this.student);

  TimeOfDay _time = TimeOfDay.now().replacing(minute: 00);
  bool iosStyle = true;

  var horarioSeg = 'Selecione o horário';
  var horarioTer = 'Selecione o horário';
  var horarioQua = 'Selecione o horário';
  var horarioQui = 'Selecione o horário';
  var horarioSex = 'Selecione o horário';
  var horarioSab = 'Selecione o horário';
  var horarioDom = 'Selecione o horário';

  final Student student;

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
                        initialValue: student.phone,
                        onSaved: (text) => student.phone = text,
                        validator: (phone) {
                          if (phone.isEmpty) return 'Campo Obrigatório';
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Telefone', border: InputBorder.none),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter()
                        ],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16,),
                      TextFormField(
                        initialValue: student.email,
                        onSaved: (text) => student.email = text,
                        decoration: const InputDecoration(
                            hintText: 'E-mail', border: InputBorder.none),
                        validator: (email) {
                          if (email.isEmpty) {
                            return 'Campo obrigatório';
                          } else if (!emailValid(email)) {
                            return 'E-mail inválido';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16,),
                      Text(
                        'Sexo:',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Consumer<Student>(
                        builder: (_, s, __) {
                          return Row(
                            children: <Widget>[
                              CustomRadioButton(
                                onTap: student.updateGender,
                                value: 'Masculino',
                                gender: student.gender,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomRadioButton(
                                  onTap: student.updateGender,
                                  value: 'Feminino',
                                  gender: student.gender,
                                ),
                              ),
                              CustomRadioButton(
                                onTap: student.updateGender,
                                value: 'Outro',
                                gender: student.gender,
                              ),
                            ],
                          );
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
                                    var voltar = await Navigator.of(context).pushNamed('/create_student_p3', arguments: student);
                                    if(voltar == 2){
                                      Navigator.of(context).pop(2);
                                    }
                                  } else {
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
