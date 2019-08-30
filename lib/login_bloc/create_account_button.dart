import 'package:flutter/material.dart';
import 'package:personal_trainer/user_repository.dart';
import 'package:personal_trainer/register/register_screen.dart';

//import 'package:personal_trainer/register/register.dart';


class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  CreateAccountButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Create an Account',
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