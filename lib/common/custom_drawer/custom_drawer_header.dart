import 'package:apppersonaltrainer/google_auth/sign_in.dart';
import 'package:apppersonaltrainer/models/page_manager.dart';
import 'package:apppersonaltrainer/models/user_manager.dart';
import 'package:apppersonaltrainer/screens/base/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (getCurrentUser() != null) {
      return Container(
        child: FlatButton(
            onPressed: () {
              signOutGoogle().whenComplete(() {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return BaseScreen();
                    },
                  ),
                );
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            color: Colors.white,
            child: Text("Sair Google")),
      );
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
        height: 180,
        child: Consumer<UserManager>(
          builder: (_, userManager, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Personal\n        Trainer',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Ola, ${userManager.user?.name ?? ''}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (userManager.isloggedIn) {
                      context.read<PageManager>().setPage(0);
                      userManager.signOut();
                    } else {
                      Navigator.of(context).pushNamed('/login');
                    }
                  },
                  child: Text(
                    userManager.isloggedIn ? 'Sair' : 'Entre ou cadastre-se >',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            );
          },
        ),
      );
    }
  }
}
