import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:personal_trainer/blocs/student_bloc.dart';
import 'package:personal_trainer/screens/student_part/dados_tecnicos.dart';
import 'package:personal_trainer/validators/student_validators.dart';
import 'package:brasil_fields/brasil_fields.dart';

class DadosAlunos extends StatefulWidget {

  final int i;
  final DocumentSnapshot student;

  DadosAlunos({this.student,this.i});


  @override
  _DadosAlunosState createState() => _DadosAlunosState(student,i);
}

class _DadosAlunosState extends State<DadosAlunos> with StudentValidator {

  final StudentBloc _studentBloc;
  final int a;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int campoGenero;
  int campoStatus = 0;
  TextEditingController name = new TextEditingController();
  TextEditingController data = new TextEditingController();
  TextEditingController cpf = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController celular = new TextEditingController();
  TextEditingController sexo = new TextEditingController();


  Map<String, dynamic> campos={
    "nome": "",
    "data": "",
    "cpf": "",
    "email": "",
    "celular": "",
    "sexo": "",
    "status" : "Ativo",
    "id": null
  };

  _DadosAlunosState(DocumentSnapshot student, this.a):
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
                return IconButton(icon: Icon(Icons.arrow_forward),
                  onPressed: (){
                    campos["nome"] = name.text;
                    campos["data"] = data.text;
                    campos["cpf"] = cpf.text;
                    campos["email"] = email.text;
                    campos["celular"] = celular.text;
                    Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) =>DadosTecnicos(campo: campos,))
                    );

                  },
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
                      //initialValue: snapshot.data["name"],
                      decoration: _buildDecoratiom("Nome"),
                      controller: name,
                      validator: validateName,
                    ),
                    SizedBox(height: 8.0), //Adicionar espaçamento entre os TextFields
                    TextFormField(
                      style: _fieldStale,
                      //initialValue: snapshot.data["birthday"],
                      decoration: _buildDecoratiom("Data de Nascimento"),
                      controller: data,
                      keyboardType: TextInputType.numberWithOptions(),
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        DataInputFormatter(),
                      ],
                      validator: validateBirthday,
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      style: _fieldStale,
                      keyboardType: TextInputType.numberWithOptions(),
                      //initialValue: snapshot.data["cpf"],
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        CpfInputFormatter(),
                      ],
                      decoration: _buildDecoratiom("CPF"),
                      controller: cpf,
                      validator: validateCpf,
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      style: _fieldStale,
                      //initialValue: snapshot.data["email"],
                      decoration: _buildDecoratiom("E-mail"),
                      validator: validateEmail,
                      controller: email,
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      style: _fieldStale,
                      keyboardType: TextInputType.phone,
                      //initialValue: snapshot.data["phone"],
                      inputFormatters:[
                        WhitelistingTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter(),
                      ],
                      decoration: _buildDecoratiom("Celular"),
                      controller: celular,
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
                    SizedBox(height: 8.0),

                    FutureBuilder(
                        future: FirebaseAuth.instance.currentUser(),
                        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                          if (snapshot.hasData) {
                            _studentBloc.saveId(snapshot.data.uid);
                            campos["id"] = snapshot.data.uid;
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

  attValorRadio(int value){
    setState(() {
      campoGenero = value;
    });

    if(campoGenero == 0){
      campos["sexo"] ="Homem";
    }
    if(campoGenero == 1){
      campos["sexo"] ="Mulher";
    }
    if(campoGenero == 2){
      campos["sexo"] ="Outro";
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

}
