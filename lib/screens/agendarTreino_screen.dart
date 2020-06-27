import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:personal_trainer/blocs/aulas_bloc.dart';
import 'package:personal_trainer/calendar/calendar_main.dart';
import 'package:personal_trainer/time.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:personal_trainer/validators/aula_avulsa_validators.dart';

class AgendarTreinoScreen extends StatefulWidget{
  final DocumentSnapshot aulas;
  AgendarTreinoScreen ({this.aulas});
  @override
  _AgendarTreinoScreenState createState() => _AgendarTreinoScreenState(aulas);
  static pegarId() {}
}

class _AgendarTreinoScreenState extends State<AgendarTreinoScreen> with AulaAvulsaValidator{
  DateTime day = DateTime.now();
  List lista = ['fabio', 'prado'];
  //final AulaBloc _aulaBloc;
  Calendar cps = new Calendar();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  static DocumentSnapshot aulas;
  
  _AgendarTreinoScreenState(DocumentSnapshot aulas);
      AulaBloc _aulaBloc = AulaBloc(aulas);

  TimeState t1 = new TimeState();
  final controllerName = TextEditingController();
  final controllerCpf = TextEditingController();
  final controllerDate = TextEditingController();
  final controllerTime = TextEditingController();
  final controllerAcademia = TextEditingController();
  final controllerDuracao = TextEditingController();
  final controllerPreco = TextEditingController();
  final controllerFrequencia = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
      title: StreamBuilder<bool>(
          stream: _aulaBloc.outCreated,
          builder: (context, snapshot) {
            return Text("Agendar Treino Avulso");
          }
        ),
      backgroundColor: Colors.deepOrange,
      actions: <Widget>[
        StreamBuilder<bool>(
            stream: _aulaBloc.outCreated,
            initialData: false,
            builder: (context,snapshot){
              if(snapshot.data)
                return StreamBuilder<bool>(
                    stream: _aulaBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(icon: Icon(Icons.remove),
                        onPressed: snapshot.data ? null : (){
                          _aulaBloc.deleteAula();
                          Navigator.of(context).pop();
                        },
                      );
                    }
                );
              else return Container();
            },
          ),
        StreamBuilder<bool>(
            builder: (context, snapshot) {
              return IconButton(icon: Icon(Icons.save),
                onPressed: (){
                  saveAula();
                  print("Aqui vai passar pro calendario!");
                },
              );
            }
          )

      ],

      ),
      body: Form(
        key: _formKey,
        child: StreamBuilder<Map>(
          stream: _aulaBloc.outData,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return Container();
            return ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[

            TextFormField(
              initialValue: snapshot.data["name"],
              onSaved: _aulaBloc.saveName,
              controller: controllerName,
              decoration: _buildDecoration("Nome:"),
              validator: validateName,
            ),
            SizedBox(height: 8.0),

            TextFormField(
              initialValue: snapshot.data["cpf"],
              keyboardType: TextInputType.numberWithOptions(),
              onSaved: _aulaBloc.saveCpf,
              controller: controllerCpf,
              decoration: _buildDecorationCpf("CPF:"),
              inputFormatters:[
                WhitelistingTextInputFormatter.digitsOnly,
                CpfInputFormatter(),
              ],
              validator: validateCpf,
            ),
            SizedBox(height: 8.0),

            TextFormField(
              readOnly: true,
              initialValue: snapshot.data["data"],
              onSaved: _aulaBloc.saveData,
              controller: controllerDate,
              decoration: _buildDecorationDate("Data:"),
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                DataInputFormatter(),
              ],
              validator: validateDate,
            ),
            SizedBox(height: 8.0), 

            TextFormField(
              readOnly: true,
              initialValue: snapshot.data["hora"],
              onSaved: _aulaBloc.saveHora,
              controller: controllerTime,
              decoration: _buildDecorationTime("Horario:"),
              keyboardType: TextInputType.numberWithOptions(),                            
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly, 
                LengthLimitingTextInputFormatter(4)                                                    
              ],
              validator: validateHour,
            ),
            SizedBox(height: 8.0),

            TextFormField(
              readOnly: true,
              initialValue: snapshot.data["academia"],
              onSaved: _aulaBloc.saveAcademia,
              controller: controllerAcademia,
              decoration: _buildDecorationAcademia("Academia:"),
              validator: validateGym,
            ),
            SizedBox(height: 8.0),

            TextFormField(
              initialValue: snapshot.data["duracao"],
              keyboardType: TextInputType.numberWithOptions(),
              onSaved: _aulaBloc.saveDuracao,
              controller: controllerDuracao,
              decoration: _buildDecoration("Duração:"),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              validator: validateDuration,
            ),
            SizedBox(height: 8.0), 

            TextFormField(
              initialValue: snapshot.data["preco"],
              keyboardType: TextInputType.numberWithOptions(),
              onSaved: _aulaBloc.savePreco,
              controller: controllerPreco,
              decoration: _buildDecoration("Preço:"),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              validator: validatePrice,
            ), 

            FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.hasData) {
                  _aulaBloc.saveId(snapshot.data.uid);
                  return Text("");
                }                                          
              }
              ),
                 
              ],
            );
          }     
        ),    
      ),
    );    
  }

  void saveAula() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Salvando aula...",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(minutes: 1),
            backgroundColor: Colors.black,
          )
      );

      bool success = await _aulaBloc.saveAula();
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(success ? "Aula salva" : "Erro ao salvar",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          )
      );
    }
  }

  InputDecoration _buildDecorationCpf(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        /*suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: (){
            consultarCpf(context);
          }                    
        ),*/
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
          controllerDate.text = await t1.selectDate(context) as String,        
                   
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
                controllerTime.text = await t1.selectTime(context) as String,
              
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

    InputDecoration _buildDecorationAcademia(String label) {
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

    InputDecoration _buildDecoration(String label) {
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

//man dps tem q add aquele codigo q tu fez de pegar só os alunos do email logado no momento aqui.
    consultarCpf(BuildContext context) async{
      FirebaseAuth.instance.currentUser();
      
      QuerySnapshot list = await Firestore.instance.collection("student").where(
      "cpf", isEqualTo: controllerCpf.text).getDocuments();
        var teste1 = list.documents.map((doc) => doc.data['cpf']);
        var teste2 = list.documents.map((doc) => doc.data['name']);
        var teste3 = list.documents.map((doc) => doc.data['email']);
        var teste4 = list.documents.map((doc) => doc.data['phone']);
        var concatenar = "CPF: $teste1 \n" + "Nome: $teste2 \n" + "Email: $teste3 \n" + "Celular: $teste4 \n"; 
        var concatenar2 = concatenar.replaceAll('(','');
        var concatenar3 = concatenar2.replaceAll(')','');

        if(teste1.isEmpty){
          print("vazio");
          exibirAlunoInexistente();
        }
        else{
          exibirDialogAluno(concatenar3); 
        }
    }

    exibirDialogAluno(String concatenar){
      Alert(
        context: context,
        title: "Dados do Aluno",
        content: Container(
          child:
            Text(concatenar),
        ),
          buttons: [
            DialogButton(
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () { 
                Navigator.pop(context);
                controllerCpf.text = "";
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

    exibirAlunoInexistente(){
      Alert(
        context: context,
        title: "Aluno não cadastrado",
        content: Container(
          child:
            Text(controllerCpf.text+" Ainda não foi cadastrado no sistema!"),
        ),
          buttons: [
            DialogButton(
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () { 
                Navigator.pop(context);
                controllerCpf.text = "";
              },
              color: Color.fromRGBO(189, 13, 13, 1.0),
            ), 
          ],
      ).show();     
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


}
