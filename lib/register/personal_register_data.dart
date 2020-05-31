import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:personal_trainer/blocs/personal_bloc.dart';

class PersonalData extends StatefulWidget {
  final DocumentSnapshot personalData;

  PersonalData({this.personalData});
  @override
  PersonalDataState createState() => PersonalDataState(personalData);

  static pegarId() {}
}

class PersonalDataState extends State<PersonalData>{
  final PersonalBloc _personalBloc;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String verificationId;  
  
  PersonalDataState(DocumentSnapshot personal):
      _personalBloc = PersonalBloc(personal);

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
        backgroundColor: Colors.deepOrange,
      ),
      body: Form(
          key: _formKey,
          child: StreamBuilder<Map>(
            stream: _personalBloc.outData,
            builder: (context, snapshot) {
              if(!snapshot.hasData) return Container();
              return ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["name"],
                    decoration: _buildDecoratiom("Nome"),
                    onSaved: _personalBloc.saveName,
                    //validator: validateName,
                  ),
                  SizedBox(height: 8.0), //Adicionar espaçamento entre os TextFields

                  TextFormField(
                    style: _fieldStale,
                    keyboardType: TextInputType.numberWithOptions(),
                    initialValue: snapshot.data["id_confef"],
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: _buildDecoratiom("CONFEF"),
                    onSaved: _personalBloc.saveConfef,
                    //validator: validateCpf,
                  ),
                  SizedBox(height: 8.0),

                  TextFormField(
                    style: _fieldStale,
                    keyboardType: TextInputType.phone,
                    initialValue: snapshot.data["phone"],
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                    decoration: _buildDecoratiom("Celular"),
                    onSaved: _personalBloc.savePhone,
                    //validator: validatePhone,
                  ),
                  SizedBox(height: 15.0),                                

                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: (){
                      savePersonal();
                      exibirMsgConfirmar();
                    },
                    child: Text('Criar Conta', style: TextStyle(color: Colors.white)),
                    disabledColor: Colors.black,
                    color: Colors.deepOrange,
                    
                  )

                  /*FutureBuilder(
                    future: FirebaseAuth.instance.currentUser(),
                      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                        if (snapshot.hasData) {
                        _personalBloc.saveEmail(snapshot.data.uid);
                        return Text("");
                        }                                          
                    }
                    
                  ),*/
                 
                ],
              );
            }
          )
      ),
    );

  }

  void exibirMsgConfirmar(){
    Scaffold.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Um email de confirmação foi enviado para seu email !"),],
        ),
      ),
    );
  }

  void savePersonal() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      

      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Salvando dados...",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(minutes: 1),
            backgroundColor: Colors.black,
          ) 
      );

      bool success = await _personalBloc.savePersonal();

      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(success ? "Dados salvos" : "Erro ao salvar",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          )
      );
    }
  }


}