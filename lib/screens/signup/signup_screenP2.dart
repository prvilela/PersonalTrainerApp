import 'package:apppersonaltrainer/helpers/validators.dart';
import 'package:apppersonaltrainer/models/user.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:brasil_fields/formatter/telefone_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignUpScreenP2 extends StatelessWidget {

  SignUpScreenP2(this.user);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
              key: formKey,
              child: Consumer<UserManager>(
                  builder: (_,userManager,__){
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      children: <Widget>[
                        TextFormField(
                          enabled: !userManager.loading,
                          decoration: const InputDecoration(hintText: 'Dia de cobrança'),
                          keyboardType: TextInputType.number,
                          validator: (day){
                            if(day.isEmpty){
                              return 'Campo obrigatório';
                            }else if(day.length > 2 || int.parse(day)>30){
                              return 'Dia de cobrança inválido';
                            }
                            else{
                              return null;
                            }
                          },
                          onSaved: (day) => user.day = int.parse(day),
                        ),
                        const SizedBox(height: 16,),
                        TextFormField(
                          enabled: !userManager.loading,
                          decoration: const InputDecoration(hintText: 'E-mail'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (email){
                            if(email.isEmpty){
                              return 'Campo obrigatório';
                            }else if(!emailValid(email)){
                              return 'E-mail inválido';
                            }else{
                              return null;
                            }
                          },
                          onSaved: (email) => user.email = email,
                        ),
                        const SizedBox(height: 16,),
                        TextFormField(
                          enabled: !userManager.loading,
                          decoration: const InputDecoration(hintText: 'Senha'),
                          autocorrect: false,
                          obscureText: true,
                          validator: (pass){
                            if(pass.length<6){
                              return 'Senha muito curta';
                            }if(pass.isEmpty){
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                          onSaved: (pass) => user.password = pass,
                        ),
                        const SizedBox(height: 16,),
                        TextFormField(
                          enabled: !userManager.loading,
                          decoration: const InputDecoration(hintText: 'Repita a senha'),
                          autocorrect: false,
                          obscureText: true,
                          validator: (pass){
                            if(pass.length<6){
                              return 'Senha muito curta';
                            }if(pass.isEmpty){
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                          onSaved: (pass) => user.confirmPassword = pass,
                        ),
                        const SizedBox(height: 16,),
                        SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: userManager.loading ? null : (){
                              if(formKey.currentState.validate()){
                                formKey.currentState.save();

                                if(user.password != user.confirmPassword){
                                  scaffoldKey.currentState.showSnackBar(
                                      const SnackBar(
                                        content: const Text('Senhas não coincidem'),
                                        backgroundColor: Colors.red,
                                      )
                                  );
                                  return;
                                }

                                userManager.signUp(
                                    user: user,
                                    onSuccess: (){
                                      debugPrint('sucesso');
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                    },
                                    onFail: (e){
                                      scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text('Falha ao cadastrar: $e'),
                                            backgroundColor: Colors.red,
                                          )
                                      );
                                    }
                                );

                              }
                            },
                            color: Theme.of(context).primaryColor,
                            disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                            textColor: Colors.white,
                            child: userManager.loading ?
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ):
                            const Text(
                              'Criar Conta',
                              style: TextStyle(
                                  fontSize: 18
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }
              )
          ),
        ),
      ),
    );
  }
}
