import 'package:flutter/cupertino.dart';

class PageManager{

  PageManager(this._pageController);

  final PageController _pageController;

  int page;

  void setPage(int value){
    if(page==value) return;
    page = value;
    _pageController.jumpToPage(value);
  }

}