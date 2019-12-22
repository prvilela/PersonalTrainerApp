import 'package:flutter/material.dart';
import 'package:personal_trainer/calendarioPacotes/schedules_page.dart';
import 'package:personal_trainer/tiles/bottomNavigation.dart';
import 'package:personal_trainer/calendar/table_calendar.dart';


class PacoteAula extends StatefulWidget {
  @override
  _PacoteAulaState createState() => _PacoteAulaState();
}

class _PacoteAulaState extends State<PacoteAula> {
  CalendarController _calendarController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BottomNavigationClass bn = new BottomNavigationClass();

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
  } 

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoratiom(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    } 
    final _fieldStale = TextStyle(color: Colors.orange[700], fontSize: 18);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pacotes de Aula'),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
              return showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Formato do horário'),
                  content: Text("horários disponíveis"), 
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Voltar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('Confirmar'),
                      onPressed: () {
                        
                        //Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            },
          )
        ],
      ),


      body: SchedulesPage(),
      //linha a seguir irá adicionar o calendário para mostrar apenas a semana escolhida
          //_buildTableCalendar(),

      bottomNavigationBar: bn,
    
    );

  }

    Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
    );
  }

}
