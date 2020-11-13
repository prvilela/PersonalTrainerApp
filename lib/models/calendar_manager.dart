import 'package:flutter/cupertino.dart';


class CalendarManager extends ChangeNotifier{

  int diaSemana;
  String dia;

  CalendarManager(){
    final date = DateTime.now();
    diaSemana=date.weekday;
    verificar();
    notifyListeners();
  }

  void addDiaSemana(){
    if(diaSemana==7){
      diaSemana=1;
    }else{
      diaSemana++;
    }
    verificar();
    notifyListeners();
  }

  void subDiaSemana(){
    if(diaSemana==1){
      diaSemana=7;
    }else{
      diaSemana--;
    }
    verificar();
    notifyListeners();
  }

  void verificar(){
    switch(diaSemana){
      case 1:
        dia="SEGUNDA";
        break;
      case 2:
        dia="TERÇA";
        break;
      case 3:
        dia="QUARTA";
        break;
      case 4:
        dia="QUINTA";
        break;
      case 5:
        dia="SEXTA";
        break;
      case 6:
        dia="SÁBADO";
        break;
      case 7:
        dia="DOMINGO";
        break;
      default:
    }
    notifyListeners();
  }

}