import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

bool isLoggedInFace = false;
Map userProfile;
final facebookLogin = FacebookLogin();

loginWithFB() async {
  final result = await facebookLogin.logInWithReadPermissions(['email']);

  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      final token = result.accessToken.token;
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
      final profile = JSON.jsonDecode(graphResponse.body);
      print(profile);
      print(
          'aquiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
      userProfile = profile;
      isLoggedInFace = true;
      break;
    case FacebookLoginStatus.cancelledByUser:
      isLoggedInFace = false;
      break;
    case FacebookLoginStatus.error:
      isLoggedInFace = false;
      break;
  }
}

_logout() {
  facebookLogin.logOut();
  isLoggedInFace = false;
}

loginStatus() {
  return isLoggedInFace;
}
