import 'package:apppersonaltrainer/models/gym.dart';
import 'package:apppersonaltrainer/models/student.dart';
import 'package:apppersonaltrainer/models/student_manager.dart';
import 'package:apppersonaltrainer/screens/base/base_screen.dart';
import 'package:apppersonaltrainer/screens/gym/gym_screen.dart';
import 'package:apppersonaltrainer/screens/login/login_screen.dart';
import 'package:apppersonaltrainer/screens/plan/plan_screen.dart';
import 'package:apppersonaltrainer/screens/signup/signup_screen.dart';
import 'package:apppersonaltrainer/screens/student/student_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/gym_manager.dart';
import 'models/plan.dart';
import 'models/planManager.dart';
import 'models/user_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_)=>UserManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager,StudentManager>(
          create: (_)=>StudentManager(),
          lazy: false,
          update: (_, userManager, studentManager){
            return studentManager..updateStudent(userManager);
          },
        ),
        ChangeNotifierProxyProvider<UserManager,GymManager>(
          create: (_)=>GymManager(),
          lazy: false,
          update: (_, userManager, gymManager){
            return gymManager..updateGym(userManager);
          },
        ),
        ChangeNotifierProxyProvider<UserManager,PlanManager>(
          create: (_)=>PlanManager(),
          lazy: false,
          update: (_, userManager, planManager){
            return planManager..updatePlan(userManager);
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Personal Trainer',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Colors.orangeAccent,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: '/base',
        onGenerateRoute: (settings){
          switch(settings.name){
            case '/login':
              return MaterialPageRoute(
                  builder: (_)=> LoginScreen()
              );
            case '/signup':
              return MaterialPageRoute(
                  builder: (_)=> SignUpScreen()
              );
            case '/edit_student':
              return MaterialPageRoute(
                  builder: (_)=> StudentScreen(settings.arguments as Student)
              );
            case '/edit_plan':
              return MaterialPageRoute(
                  builder: (_)=> PlanScreen(settings.arguments as Plan)
              );
            case '/edit_gym':
              return MaterialPageRoute(
                  builder: (_)=> GymScreen(settings.arguments as Gym)
              );
            case '/base':
            default:
              return MaterialPageRoute(
                builder: (_)=> BaseScreen()
              );
          }
        },
      ),
    );
  }
}
