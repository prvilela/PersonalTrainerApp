import 'package:apppersonaltrainer/models/gym.dart';
import 'package:apppersonaltrainer/models/gym_manager.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:brasil_fields/formatter/cep_input_formatter.dart';
import 'package:brasil_fields/formatter/real_input_formatter.dart';
import 'package:brasil_fields/formatter/telefone_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GymScreen extends StatelessWidget {

  GymScreen(Gym g):
        editing = g!=null,
        gym = g!=null ? g : Gym()
  ;

  final Gym gym;
  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final rua = TextEditingController();
  final cep = TextEditingController();

  @override
  Widget build(BuildContext context) {
    rua.text = gym.rua;
    cep.text = gym.location;
    return ChangeNotifierProvider.value(
      value: gym,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(editing?'Editar Academia':'Criar Academia'),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            if(editing)
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: (){
                  gym.remove();
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
                      initialValue: gym.name,
                      onSaved: (name) => gym.name=name,
                      decoration: const InputDecoration(
                          labelText: 'Nome',
                          border: InputBorder.none
                      ),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                      ),
                      validator: (name){
                        if(name.isEmpty){
                          return 'Campo Obrigatario';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: gym.phone,
                      onSaved: (phone) => gym.phone=phone,
                      decoration: const InputDecoration(
                          labelText: 'Telefone',
                          border: InputBorder.none
                      ),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter()
                      ],
                      validator: (name){
                        if(name.isEmpty){
                          return 'Campo Obrigatario';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: gym.price ==null?
                      null:gym.price.toString(),
                      onSaved: (price) => gym.price=num.parse(price.replaceAll(',', '.')),
                      decoration: const InputDecoration(
                          labelText: 'Preço',
                          border: InputBorder.none
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        RealInputFormatter(centavos: true)
                      ],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                      ),
                      validator: (name){
                        if(name.isEmpty){
                          return 'Campo Obrigatario';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: cep,
                      decoration: InputDecoration(
                        labelText: 'CEP',
                        border: InputBorder.none,
                        hintText: '12.345-678',
                        suffixIcon: IconButton(
                          onPressed: ()async{
                            rua.text = await gym.getAddress(cep.text);
                          },
                          icon: Icon(Icons.search),
                        ),
                      ),
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        CepInputFormatter()
                      ],
                      keyboardType: TextInputType.number,
                      validator: (text){
                        if(text.isEmpty){
                          return 'Campo Obrigatório';
                        }else if(text.length !=10){
                          return 'Cep Inválido';
                        }else{
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: rua,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Endereço:'
                      ),
                      onSaved: (text) => gym.rua=text,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                      ),
                      validator: (rua){
                        if(rua.isEmpty)
                          return 'Campo Obrigatório!';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20,),
                    Consumer<UserManager>(
                      builder: (_,user,__){
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: ()async{
                              if(user.isloggedIn){
                                if(formKey.currentState.validate()){
                                  formKey.currentState.save();
                                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                                  gym.idPersonal = user.uid;
                                  gym.save();
                                  Navigator.of(context).pop();
                                }else{
                                  scaffoldKey.currentState.showSnackBar(
                                      const SnackBar(
                                        content: const Text('Existem campos vazios ou preenchidos incorretamente!'),
                                        backgroundColor: Colors.red,
                                      )
                                  );
                                }
                              }else{
                                Navigator.of(context).pushNamed('/login');
                              }
                            },
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                            child: Text(
                              user.isloggedIn? 'Salvar':'Entre para Cadastrar',
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
          ),
        ),
      ),
    );
  }
}
