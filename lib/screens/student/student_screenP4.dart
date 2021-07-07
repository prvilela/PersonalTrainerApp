import 'package:apppersonaltrainer/common/custom_check_button.dart';
import 'package:apppersonaltrainer/common/custom_radio_button.dart';
import 'package:apppersonaltrainer/helpers/validators.dart';
import 'package:apppersonaltrainer/models/gym_manager.dart';
import 'package:apppersonaltrainer/models/planManager.dart';
import 'package:apppersonaltrainer/models/student.dart';
import 'package:apppersonaltrainer/models/student_manager.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'components/choose_dialog.dart';
import 'components/time_day_week.dart';

class StudentScreenP4 extends StatelessWidget {

  StudentScreenP4(this.student);

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
                        initialValue: student.restriction,
                        onSaved: (text) => student.restriction = text,
                        decoration: const InputDecoration(
                            hintText: 'Restrições', border: InputBorder.none),
                        maxLines: 2,
                        validator: (res) {
                          if (res.isEmpty) return 'Campo Obrigatório';
                          return null;
                        },
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16,),
                      TextFormField(
                        initialValue: student.goal,
                        onSaved: (text) => student.goal = text,
                        maxLines: 2,
                        decoration: const InputDecoration(
                            hintText: 'Objetivo', border: InputBorder.none),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                        validator: (goal) {
                          if (goal.isEmpty) return 'Campo Obrigatório';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16,),
                      Text(
                        'Dias:',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Consumer2<Student, StudentManager>(
                        builder: (_, s, studentManager, __) {
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomCheckButton(
                                      value: 'Dom',
                                      onTap: student.updateDays,
                                      isChecked: student.days.dom,
                                    ),
                                    TimeDayWeek(
                                      student: student,
                                      value: 'Dom',
                                      initial: student.days.horarioDom,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomCheckButton(
                                      value: 'Seg',
                                      onTap: student.updateDays,
                                      isChecked: student.days.seg,
                                    ),
                                    TimeDayWeek(
                                      student: student,
                                      value: 'Seg',
                                      initial: student.days.horarioSeg,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomCheckButton(
                                      value: 'Ter',
                                      onTap: student.updateDays,
                                      isChecked: student.days.ter,
                                    ),
                                    TimeDayWeek(
                                      student: student,
                                      value: 'Ter',
                                      initial: student.days.horarioTer,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomCheckButton(
                                      value: 'Quar',
                                      onTap: student.updateDays,
                                      isChecked: student.days.quar,
                                    ),
                                    TimeDayWeek(
                                        student: student,
                                        value: 'Quar',
                                        initial: student.days.horarioQuar),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomCheckButton(
                                      value: 'Quin',
                                      onTap: student.updateDays,
                                      isChecked: student.days.quin,
                                    ),
                                    TimeDayWeek(
                                        student: student,
                                        value: 'Quin',
                                        initial: student.days.horarioQuin),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomCheckButton(
                                      value: 'Sex',
                                      onTap: student.updateDays,
                                      isChecked: student.days.sex,
                                    ),
                                    TimeDayWeek(
                                        student: student,
                                        value: 'Sex',
                                        initial: student.days.horarioSex),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomCheckButton(
                                      value: 'Sab',
                                      onTap: student.updateDays,
                                      isChecked: student.days.sab,
                                    ),
                                    TimeDayWeek(
                                        student: student,
                                        value: 'Sab',
                                        initial: student.days.horarioSab),
                                  ],
                                ),
                              ]);
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
                                    student.save();
                                    Navigator.of(context).pop(2);
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
                                    ? 'Salvar'
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
