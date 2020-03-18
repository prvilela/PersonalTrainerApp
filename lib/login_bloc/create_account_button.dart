import 'package:flutter/material.dart';
import 'package:personal_trainer/user_repository.dart';
import 'package:personal_trainer/register/register_screen.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  CreateAccountButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.deepOrange,
      child: Text(
        'Crie uma Conta',
        style: TextStyle(color:Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return RegisterScreen(userRepository: _userRepository);
          }),
        );
      },
    );
  }
}