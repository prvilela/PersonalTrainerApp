import 'package:apppersonaltrainer/models/plan.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:brasil_fields/formatter/cpf_input_formatter.dart';
import 'package:brasil_fields/formatter/real_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PlanScreen extends StatelessWidget {

  PlanScreen(Plan p):
        editing = p!=null,
        plan = p!=null ? p : Plan()
  ;

  final Plan plan;
  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: plan,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(editing?'Editar Plano':'Criar Plano'),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            if(editing)
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: (){
                  plan.remove();
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
                      initialValue: plan.name,
                      onSaved: (name) => plan.name=name,
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
                      initialValue: plan.duration==null ?
                      null:plan.duration.toString(),
                      onSaved: (quant) => plan.duration=int.parse(quant),
                      decoration: const InputDecoration(
                          labelText: 'Duração da aula: (em minutos)',
                          border: InputBorder.none
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                      ),
                      validator: (quant){
                        if(quant.isEmpty){
                          return 'Campo Obrigatario';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: plan.pricePerClass==null? null:
                      plan.pricePerClass.toString()
                      ,
                      onSaved: (price) => plan.pricePerClass=num.parse(price.replaceAll(',', '.')),
                      decoration: const InputDecoration(
                          labelText: 'Preço por Aula',
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
                      validator: (price){
                        if(price.isEmpty){
                          return 'Campo Obrigatario';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: plan.quantityMonths==null
                          ?null:plan.quantityMonths.toString(),
                      onSaved: (quant) => plan.quantityMonths=int.parse(quant),
                      decoration: const InputDecoration(
                          labelText: 'Duração: (em meses)',
                          border: InputBorder.none
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                      ),
                      validator: (quant){
                        if(quant.isEmpty){
                          return 'Campo Obrigatario';
                        }
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
                                  plan.idPersonal = user.uid;
                                  plan.save();
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
