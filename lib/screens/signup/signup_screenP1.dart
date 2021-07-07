import 'package:apppersonaltrainer/helpers/validators.dart';
import 'package:apppersonaltrainer/models/user.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:brasil_fields/formatter/telefone_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final User user = User();

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
                          decoration: const InputDecoration(hintText: 'Nome Completo'),
                          validator: (name){
                            if(name.isEmpty){
                              return 'Campo obrigatório';
                            }else if(name.trim().split(' ').length <=1){
                              return 'Preencha seu nome completo';
                            }
                            return null;
                          },
                          onSaved: (name)=>user.name=name,
                        ),
                        const SizedBox(height: 16,),
                        TextFormField(
                          enabled: !userManager.loading,
                          decoration: const InputDecoration(hintText: 'Telefone'),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter(),
                          ],
                          validator: (phone){
                            if(phone.isEmpty){
                              return 'Campo obrigatório';
                            }{
                              return null;
                            }
                          },
                          onSaved: (phone) => user.phone = phone,
                        ),
                        const SizedBox(height: 16,),
                        TextFormField(
                          enabled: !userManager.loading,
                          decoration: const InputDecoration(hintText: 'COEF'),
                          keyboardType: TextInputType.number,
                          validator: (coef){
                            if(coef.isEmpty){
                              return 'Campo obrigatório';
                            }else{
                              return null;
                            }
                          },
                          onSaved: (coef) => user.coef = coef,
                        ),
                        const SizedBox(height: 16,),
                        SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: userManager.loading ? null : (){
                              if(formKey.currentState.validate()){
                                formKey.currentState.save();


                                Navigator.of(context).pushNamed('signup_p2', arguments: user);
                                /*userManager.signUp(
                                    user: user,
                                    onSuccess: (){
                                      debugPrint('sucesso');
                                      Navigator.of(context).pop();
                                    },
                                    onFail: (e){
                                      scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text('Falha ao cadastrar: $e'),
                                            backgroundColor: Colors.red,
                                          )
                                      );
                                    }
                                );*/

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
