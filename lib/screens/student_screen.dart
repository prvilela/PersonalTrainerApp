import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:personal_trainer/Widget/gym_tile.dart';
import 'package:personal_trainer/blocs/student_bloc.dart';
import 'package:personal_trainer/tabs/gym_tab.dart';
import 'package:personal_trainer/tabs/student_tab.dart';
import 'package:personal_trainer/validators/student_validators.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  TextEditingController name = new TextEditingController();
  TextEditingController birthday = new TextEditingController();
  TextEditingController cpf = new TextEditingController();
  TextEditingController objetivos = new TextEditingController();
  TextEditingController restrictions = new TextEditingController();
  TextEditingController academia = new TextEditingController();
  var retorno;
  
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


    final _fieldStale = TextStyle(color: Colors.orange[700], fontSize: 18);

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
                      TelefoneInputFormatter(digito_9: true),
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
                  
                  Row(
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
                  ),

         
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["gym"],
                    decoration: _buildDecorationGym("Academia"),
                    onSaved: _studentBloc.saveGym,
                    controller: academia,
                       
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
                    }
                    
                  ),
                 
                ],
              );
            }
            
          )
      ),
    );

  }

  atualizarNomeAcademia(name){
    setState(() async {
      retorno = name;
      academia.text = await name;
    });
    
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

    exibirAlertaAcademias(names){
      Color color1 = Colors.black;
      Color color2 = Colors.deepOrange;
      Alert(
        context: context,
        title: "Academias cadastradas",
        content: Container(      
            height: MediaQuery.of(context).size.height  * 0.4,
            width: MediaQuery.of(context).size.height  * 0.3,
            child:
            ListView.builder(           
              shrinkWrap: true,
              itemCount: names.length,
              itemBuilder: (BuildContext context, int index){
                return 
                  FlatButton(            
                    textColor: color1,
                    highlightColor: Colors.orange,
                    child: Text(names[index], style: TextStyle(fontSize: 20,),),
                    onPressed: (){
                      var nome = names[index];           
                      academia.text = "$nome";
                      setState(() {
                        names[index] = Colors.red;
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
                academia.text = "";
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


}
