import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:personal_trainer/blocs/student_bloc.dart';
import 'package:personal_trainer/tabs/gym_tab.dart';
import 'package:personal_trainer/validators/student_validators.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:personal_trainer/time.dart';

class StudentScreen extends StatefulWidget{
  final DocumentSnapshot student;

  StudentScreen({this.student});
  @override
  StudentScreenState createState() => StudentScreenState(student);
  static pegarId() {}
}

class StudentScreenState extends State<StudentScreen> with StudentValidator{
  final StudentBloc _studentBloc;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GymTabState gts = new GymTabState();

  int campoGenero;
  int campoStatus = 0;
  TimeState t1 = TimeState();
  final name = TextEditingController();
  final birthday = TextEditingController();
  final cpf = TextEditingController();
  final objetivos = TextEditingController();
  final restrictions = TextEditingController();
  final controllerAcademia = TextEditingController();
  final plano = TextEditingController();
  final data = TextEditingController();
  final hora = TextEditingController();
  final quantidade = TextEditingController();

  Map<String, bool> days ={
    "segunda": false,
    "terca"  : false,
    "quarta" : false,
    "quinta" : false,
    "sexta"  : false,
    "sabado" : false,
    "domingo": false
  };

  static DocumentSnapshot student;

  StudentScreenState(DocumentSnapshot student):
      _studentBloc = StudentBloc(student);

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoratiom(String label) {
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


    final _fieldStale = TextStyle(color: Colors.orange[700], fontSize: 18);
    name.text = "";
    birthday.text = "";
    cpf.text = "";
    objetivos.text ="";
    restrictions.text ="";
    controllerAcademia.text ="";
    plano.text ="";
    hora.text ="";
    data.text = "";

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: StreamBuilder<bool>(
          stream: _studentBloc.outCreated,
          initialData: false,
          builder: (context, snapshot) {
            return Text(snapshot.data ? "Editar Aluno":"Cadastrar Aluno");
          }
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: <Widget>[
         StreamBuilder<bool>(
            stream: _studentBloc.outCreated,
            initialData: false,
            builder: (context,snapshot){
              if(snapshot.data)
                return StreamBuilder<bool>(
                    stream: _studentBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(icon: Icon(Icons.remove),
                        onPressed: snapshot.data ? null : (){
                          _studentBloc.deleteStudent();
                          Navigator.of(context).pop();
                        },
                      );
                    }
                );
              else return Container();
            },
          ),
          StreamBuilder<bool>(
            stream: _studentBloc.outLoading,
            builder: (context, snapshot) {
              return IconButton(icon: Icon(Icons.save),
                onPressed: saveStudent,
              );
            }
          )
        ],
      ),
      body: Form(
          key: _formKey,
          child: StreamBuilder<Map>(
            stream: _studentBloc.outData,
            builder: (context, snapshot) {
              if(!snapshot.hasData) return Container();
              inicializarControlers(snapshot);
              return ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["name"],
                    decoration: _buildDecoratiom("Nome"),
                    //controller: name,
                    onSaved: _studentBloc.saveName,
                    validator: validateName,
                  ),
                  SizedBox(height: 8.0), //Adicionar espaçamento entre os TextFields
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["birthday"],
                    decoration: _buildDecoratiom("Data de Nascimento"),
                    //controller: birthday,
                    keyboardType: TextInputType.numberWithOptions(),
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      DataInputFormatter(),
                    ],
                    onSaved: _studentBloc.saveBirthday,
                    validator: validateBirthday,
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    style: _fieldStale,
                    keyboardType: TextInputType.numberWithOptions(),
                    initialValue: snapshot.data["cpf"],
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    decoration: _buildDecoratiom("CPF"),
                    //controller: cpf,
                    onSaved: _studentBloc.saveCpf,
                    validator: validateCpf,
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["email"],
                    decoration: _buildDecoratiom("E-mail"),
                    onSaved: _studentBloc.saveEmail,
                    validator: validateEmail,
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    style: _fieldStale,
                    keyboardType: TextInputType.phone,
                    initialValue: snapshot.data["phone"],
                    inputFormatters:[
                      WhitelistingTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                    decoration: _buildDecoratiom("Celular"),
                    onSaved: _studentBloc.savePhone,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Radio(
                        value: 0,
                        activeColor: Colors.deepOrange,
                        groupValue: campoGenero,
                        onChanged: attValorRadio,
                      ),
                      Text("Homem", style: TextStyle(color: Colors.deepOrange)),

                      Radio(
                        value: 1,
                        activeColor: Colors.deepOrange,
                        groupValue: campoGenero,
                        onChanged: attValorRadio,
                      ),
                      Text("Mulher", style: TextStyle(color: Colors.deepOrange)),

                      Radio(
                        value: 2,
                        activeColor: Colors.deepOrange,
                        groupValue: campoGenero,
                        onChanged: attValorRadio,
                      ),
                      Text("Outro", style: TextStyle(color: Colors.deepOrange)),
                    ]                      
                  ),
                  
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Radio(
                        value: 0,
                        activeColor: Colors.deepOrange,
                        groupValue: campoStatus,
                        onChanged: attCampoStatus,                    
                      ),
                      Text("Ativo", style: TextStyle(color: Colors.deepOrange)),
                      
                      Radio(
                        value: 1,
                        activeColor: Colors.deepOrange,
                        groupValue: campoStatus,
                        onChanged: attCampoStatus2,
                      ),
                      Text("Não Ativo", style: TextStyle(color: Colors.deepOrange)),
                    ]                  
                  ),*/
  
                  TextFormField(
                    readOnly: true,
                    style: _fieldStale,
                    //initialValue: snapshot.data["gym"],
                    controller: controllerAcademia,
                    decoration: _buildDecorationGym("Academia"),
                    onSaved: _studentBloc.saveGym,
                    
                  ),      
                  SizedBox(height: 8.0),

                  SizedBox(height: 8.0),
                  Text("Dias de aula:", style: _fieldStale,),

                  Row(
                    children: <Widget>[
                      Text("Segunda", style: _fieldStale,),
                      Checkbox(
                        onChanged: (bool value) {
                          setState(() {
                            days["segunda"] = value;
                          });
                        },
                        value: days["segunda"],
                        activeColor: Colors.deepOrange,
                      ),
                      SizedBox(width: 6.0),
                      Text("Terça", style: _fieldStale,),
                      Checkbox(
                        onChanged: (bool value) {
                          setState(() {
                            days["terca"] = value;
                          });
                        },
                        value: days["terca"],
                        activeColor: Colors.deepOrange,
                      ),
                      SizedBox(width: 7.0),
                      Text("Quarta", style: _fieldStale,),
                      Checkbox(
                        onChanged: (bool value) {
                          setState(() {
                            days["quarta"] = value;
                          });
                        },
                        value: days["quarta"],
                        activeColor: Colors.deepOrange,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Quinta", style: _fieldStale,),
                      Checkbox(
                        onChanged: (bool value) {
                          setState(() {
                            days["quinta"] = value;
                          });
                        },
                        value: days["quinta"],
                        activeColor: Colors.deepOrange,
                      ),
                      SizedBox(width: 8.0),
                      Text("Sexta", style: _fieldStale,),
                      Checkbox(
                        onChanged: (bool value) {
                          setState(() {
                            days["sexta"] = value;
                          });
                        },
                        value: days["sexta"],
                        activeColor: Colors.deepOrange,
                      ),
                      SizedBox(width: 8.0),
                      Text("Sabado", style: _fieldStale,),
                      Checkbox(
                        onChanged: (bool value) {
                          setState(() {
                            days["sabado"] = value;
                          });
                        },
                        value: days["sabado"],
                        activeColor: Colors.deepOrange,
                      ),
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      Text("Domingo", style: _fieldStale,),
                      Checkbox(
                        onChanged: (bool value) {
                          setState(() {
                            days["domingo"] = value;
                          });
                        },
                        value: days["domingo"],
                        activeColor: Colors.deepOrange,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0), 

                  TextFormField(
                    readOnly: true,
                    //initialValue: snapshot.data["hora"],
                    onSaved: _studentBloc.saveHora,
                    controller: hora,
                    decoration: _buildDecorationTime("Horario:"),
                    keyboardType: TextInputType.numberWithOptions(),                            
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly, 
                      LengthLimitingTextInputFormatter(4)                                                    
                    ],
                    style: _fieldStale,
                    //validator: validateHour,
                    ),
                    SizedBox(height: 8.0),

                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["goal"],
                    decoration: _buildDecoratiom("Objetivos"),
                    //controller: objetivos,
                    maxLines: 2,
                    onSaved: _studentBloc.saveGoal,
                  ),
                  SizedBox(height: 8.0),

                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["restrictions"],
                    decoration: _buildDecoratiom("Restrições"),
                    //controller: restrictions,
                    maxLines: 2,
                    onSaved: _studentBloc.saveRestrictions,
                  ),
                  
                  SizedBox(height: 8.0),

                  TextFormField(
                    readOnly: true,
                    style: _fieldStale,
                    //initialValue: snapshot.data["plano"],
                    decoration: _buildDecorationPlano("Plano"),
                    onSaved: (texto){
                      _studentBloc.savePlano(texto);
                      _studentBloc.saveQuanti(quantidade.text);
                    },
                    controller: plano,
                  ),      
                  SizedBox(height: 8.0),

                  FutureBuilder(
                    future: FirebaseAuth.instance.currentUser(),
                      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                        if (snapshot.hasData) {
                        _studentBloc.saveId(snapshot.data.uid);
                        if(campoStatus == 0){
                          _studentBloc.saveStatus("Ativo");
                        }
                        else{
                          _studentBloc.saveStatus("Não Ativo");
                        }
                        
                        return Text("");
                        }
                        return Text("");
                    }
                    
                  ),

                ],
              );
            }
            
          )
      ),
    );

  }

  void inicializarControlers(AsyncSnapshot snapshot ){
    name.text = snapshot.data["name"];
    birthday.text = snapshot.data["birthday"];
    cpf.text = snapshot.data["cpf"];
    objetivos.text =snapshot.data["goal"];
    restrictions.text =snapshot.data["restrictions"];
    controllerAcademia.text =snapshot.data["gym"];
    plano.text =snapshot.data["plano"];
    hora.text =snapshot.data["hora"];
    data.text = "";
  }

  attValorRadio(int value){
    setState(() {
      campoGenero = value;
    });

    if(campoGenero == 0){
      _studentBloc.saveGender("Homem");
    }
    if(campoGenero == 1){
      _studentBloc.saveGender("Mulher");
    }
    if(campoGenero == 2){
      _studentBloc.saveGender("Outro");
    }

  }

  attCampoStatus(int value){
    setState(() {
      campoStatus = 0;
    });
    _studentBloc.saveStatus("Ativo");
  }

    attCampoStatus2(int value){
    setState(() {
      campoStatus = 1;
    });
    _studentBloc.saveStatus("Não Ativo");
  }


  void saveStudent() async {

    _studentBloc.saveDays(days);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Salvando aluno...",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(minutes: 1),
            backgroundColor: Colors.black,
          )
      );

      bool success = await _studentBloc.saveStudent();
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(success ? "Aluno salvo" : "Erro ao salvar",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          )
      );
    }
  }

  InputDecoration _buildDecorationGym(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: (){
            listarAcademias(context);
          }                    
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    }

    InputDecoration _buildDecorationPlano(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.yellow[700]),
        suffixIcon: IconButton(
          icon: Icon(Icons.find_in_page),
          onPressed: (){
            listarPlanos(context);
          }                    
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    }

    InputDecoration _buildDecorationDate(String label) {
      return InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async => 
          data.text = await t1.selectDate(context) as String,        
                   
        ),
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    }

    InputDecoration _buildDecorationTime(String label){
            return InputDecoration(
              labelText: label,
              counterText: null,
              suffixIcon: IconButton(
                icon: Icon(Icons.access_time),
                onPressed: () async =>
                hora.text = await t1.selectTime(context) as String,
              
        ),
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    }


    listarAcademias(BuildContext context) async{
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String sid = user.uid;
      print(sid);
      QuerySnapshot list = await Firestore.instance.collection("gym").where("id", isEqualTo: sid).getDocuments();
      var names = list.documents.map((doc) => doc.data['name']);
      var concatenar1 = " $names";
      var concatenar2 = concatenar1.replaceAll('(','');
      var concatenar3 = concatenar2.replaceAll(')','');
      var concatenar4 = concatenar3.split(",");
      print(names);
      exibirAlertaAcademias(concatenar4);
    }

    var color0 = Colors.white;
    var color1 = Colors.black;
    int _selectedIndex = 0;
    exibirAlertaAcademias(names){
      showDialog(
        context: context,
        builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Academias Cadastradas"),
              content: Container(      
              height: MediaQuery.of(context).size.height  * 0.4,
              width: MediaQuery.of(context).size.height  * 0.3,
              child:
              ListView.builder(           
                shrinkWrap: true,
                itemCount: names.length,
                itemBuilder: (BuildContext context, int index){
                  return FlatButton(            
                    textColor: color1, 
                    color: _selectedIndex != null && _selectedIndex == index
                  ? Colors.orange
                  : Colors.white,
                    highlightColor: Colors.orange,
                    child: Text(names[index], style: TextStyle(fontSize: 20, color: color1),),
                    onPressed: (){
                      var nome = names[index];           
                      controllerAcademia.text = "$nome";
                      setState(() {
                        _onSelected(index);
                      });                    
                    }
                  );                      
                }            
              )
            ),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                  controllerAcademia.text = "";
                  Navigator.pop(context);  
                 },        
                  child: Text("Cancelar", style: TextStyle(color: Colors.red),),
              ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text("Confirmar", style: TextStyle(color: Colors.green),),
                ),
              ],
            );
          },
        );
      },
    ); 
    }

    _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }


  listarPlanos(BuildContext context) async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String sid = user.uid;
    print(sid);
    QuerySnapshot list = await Firestore.instance.collection("pacote").where("idPersonal", isEqualTo: sid).getDocuments();
    var pacotes = list.documents.map((doc) => doc.data['type']);
    var precos = list.documents.map((doc) => doc.data["quantidade"]);
    print('oe');
    print(precos);
    var concatenar1 = " $pacotes";
    var concatenar2 = concatenar1.replaceAll('(','');
    var concatenar3 = concatenar2.replaceAll(')','');
    var concatenar4 = concatenar3.split(",");
    var aux = "$precos".replaceAll('(', '').replaceAll(')', '').split(",");

    exibirAlertaPacotes(concatenar4,aux);
  }

    exibirAlertaPacotes(pacotes,aux){
      Color color1 = Colors.black;
      Color color2 = Colors.deepOrange;
      Alert(
        context: context,
        title: "Pacotes cadastrados",
        content: Container(      
            height: MediaQuery.of(context).size.height  * 0.4,
            width: MediaQuery.of(context).size.height  * 0.3,
            child:
            ListView.builder(           
              shrinkWrap: true,
              itemCount: pacotes.length,
              itemBuilder: (BuildContext context, int index){
                return 
                  FlatButton(            
                    textColor: color1,
                    highlightColor: Colors.orange,
                    child: Text(pacotes[index], style: TextStyle(fontSize: 20,),),
                    onPressed: (){
                      var nome = pacotes[index];
                      var quant = aux[index];
                      plano.text = "$nome";
                      quantidade.text = "$quant";
                      setState(() {
                        pacotes[index] = Colors.red;
                        color1 = color2;
                      });
                    }
                  );                      
              }
              
            )
        ),
          buttons: [
            DialogButton(
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () { 
                Navigator.pop(context);
                plano.text = "";
              },
              color: Color.fromRGBO(189, 13, 13, 1.0),
            ), 
            DialogButton(
              child: Text(
                "Confirmar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: Color.fromRGBO(30, 200, 30, 1.0)
            )
          ],
      ).show();
    }



  void inicializar(AsyncSnapshot snapshot){
    if(snapshot.hasData){
      days["segunda"] = snapshot.data["days"]["segunda"];
      days["terca"] = snapshot.data["days"]["terca"];
      days["quarta"] = snapshot.data["days"]["quarta"];
      days["quinta"] = snapshot.data["days"]["quinta"];
      days["sexta"] = snapshot.data["days"]["sexta"];
      days["sabado"] = snapshot.data["days"]["sabado"];
      days["domingo"] = snapshot.data["days"]["domingo"];
    }
  }

}
