import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String title;
  final PageController pageController;
  final int page;

  DrawerTile(this.icon,this.title,this.pageController,this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          pageController.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32,
                color: pageController.page.round() == page ?
                    Colors.white:Colors.white,
              ),
              SizedBox(height: 32.0,),
              Text(
                title,
                style: TextStyle(
                  color: pageController.page.round() == page ?
                      Colors.white: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
