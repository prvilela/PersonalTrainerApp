import 'package:apppersonaltrainer/common/custom_check_button.dart';
import 'package:apppersonaltrainer/common/custom_radio_button.dart';
import 'package:apppersonaltrainer/helpers/validators.dart';
import 'package:apppersonaltrainer/models/gym_manager.dart';
import 'package:apppersonaltrainer/models/planManager.dart';
import 'package:apppersonaltrainer/models/student.dart';
import 'package:apppersonaltrainer/models/student_manager.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'components/choose_dialog.dart';
import 'components/time_day_week.dart';

class StudentScreen extends StatelessWidget {
  StudentScreen(Student s)
      : editing = s != null,
        student = s != null ? s : Student();

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
  final bool editing;

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
          title: Text(editing ? 'Editar Aluno' : 'Criar Aluno'),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            if (editing)
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  student.remove();
                  Navigator.of(context).pop();
                },
              )
          ],
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
                      Text(
                        'Status:',
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
                                onTap: student.updateStatus,
                                value: 'Ativo',
                                gender: student.status,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomRadioButton(
                                  onTap: student.updateStatus,
                                  value: 'Não Ativo',
                                  gender: student.status,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: plan,
                        onSaved: (text) => student.plano = text,
                        decoration: InputDecoration(
                          hintText: 'Plano',
                          border: InputBorder.none,
                          suffixIcon: Consumer<PlanManager>(
                            builder: (_, planManager, __) {
                              return IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () async {
                                    final text = await showDialog(
                                        context: context,
                                        builder: (_) => ChooseDialog(
                                              titulo: "Planos Cadastradas",
                                              names: planManager.names,
                                            ));
                                    student.quantityMonths =
                                        planManager.quantity(text);
                                    plan.text = text;
                                  });
                            },
                          ),
                        ),
                        validator: (plan) {
                          if (plan.isEmpty) return 'Campo Obrigatório';
                          return null;
                        },
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: gym,
                        onSaved: (text) => student.gym = text,
                        decoration: InputDecoration(
                          hintText: 'Academia',
                          border: InputBorder.none,
                          suffixIcon: Consumer<GymManager>(
                            builder: (_, gymManager, __) {
                              return IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () async {
                                    final text = await showDialog(
                                        context: context,
                                        builder: (_) => ChooseDialog(
                                              titulo: "Academias Cadastradas",
                                              names: gymManager.names,
                                            ));
                                    gym.text = text;
                                  });
                            },
                          ),
                        ),
                        validator: (gym) {
                          if (gym.isEmpty) return 'Campo Obrigatório';
                          return null;
                        },
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
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
                      //TextFormField(
                      /*            initialValue: student.days.horario,
                        onSaved: (text) => student.days.horario = text,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                        keyboardType: TextInputType.datetime,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          HoraInputFormatter()
                        ],
                        decoration: InputDecoration(
                          hintText: 'Horario',
                          border: InputBorder.none,
                        ),
                        validator: (time) {
                          if (time.isEmpty) {
                            return 'Campo obrigatório';
                          } else if (!time.contains(':')) {
                            return 'Horario inválido! A hora e os minutos devem ser dividios por dois pontos.';
                          } else {
                            List<String> aux = time.split(':');
                            if (aux[0].length != 2 ||
                                int.parse(aux[0]) > 23 ||
                                int.parse(aux[0]) < 0) {
                              return 'Horario inválido e a hora deve ter com dois digitos.';
                            } else if (aux[1].length != 2 ||
                                int.parse(aux[1]) >= 60 ||
                                int.parse(aux[1]) < 0) {
                              return 'Horario inválido e os minutos devem ter com dois digitos.';
                            }
                            return null;
                          }
                        }, */
                      //),

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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomCheckButton(
                                  value: 'Dom',
                                  onTap: student.updateDays,
                                  isChecked: student.days.dom,
                                ),
                                TimeDayWeek(student: student,value: 'Dom', initial: student.days.horarioDom,),

                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomCheckButton(
                                  value: 'Seg',
                                  onTap: student.updateDays,
                                  isChecked: student.days.seg,
                                ),
                                TimeDayWeek(student: student,value: 'Seg',initial: student.days.horarioSeg,),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomCheckButton(
                                  value: 'Ter',
                                  onTap: student.updateDays,
                                  isChecked: student.days.ter,
                                ),
                                TimeDayWeek(student: student,value: 'Ter',initial: student.days.horarioTer,),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomCheckButton(
                                  value: 'Quar',
                                  onTap: student.updateDays,
                                  isChecked: student.days.quar,
                                ),
                                TimeDayWeek(student: student,value: 'Quar',initial: student.days.horarioQuar),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomCheckButton(
                                  value: 'Quin',
                                  onTap: student.updateDays,
                                  isChecked: student.days.quin,
                                ),
                                TimeDayWeek(student: student,value: 'Quin',initial: student.days.horarioQuin),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomCheckButton(
                                  value: 'Sex',
                                  onTap: student.updateDays,
                                  isChecked: student.days.sex,
                                ),
                                TimeDayWeek(student: student,value: 'Sex',initial: student.days.horarioSex),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomCheckButton(
                                  value: 'Sab',
                                  onTap: student.updateDays,
                                  isChecked: student.days.sab,
                                ),
                                TimeDayWeek(student: student,value: 'Sab',initial: student.days.horarioSab),
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
                                    student.plano = plan.text;
                                    FirebaseUser user = await FirebaseAuth
                                        .instance
                                        .currentUser();
                                    student.idPersonal = user.uid;
                                    student.save();
                                    Navigator.of(context).pop();
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
