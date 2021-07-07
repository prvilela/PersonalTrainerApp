import 'package:apppersonaltrainer/models/calendar_manager.dart';
import 'package:apppersonaltrainer/models/gym.dart';
import 'package:apppersonaltrainer/models/student.dart';
import 'package:apppersonaltrainer/models/student_manager.dart';
import 'package:apppersonaltrainer/models/user.dart';
import 'package:apppersonaltrainer/screens/base/base_screen.dart';
import 'package:apppersonaltrainer/screens/gym/gym_screen.dart';
import 'package:apppersonaltrainer/screens/login/login_screen.dart';
import 'package:apppersonaltrainer/screens/plan/plan_screen.dart';
import 'package:apppersonaltrainer/screens/signup/signup_screenP1.dart';
import 'package:apppersonaltrainer/screens/signup/signup_screenP2.dart';
import 'package:apppersonaltrainer/screens/student/student_screen.dart';
import 'package:apppersonaltrainer/screens/student/student_screenP1.dart';
import 'package:apppersonaltrainer/screens/student/student_screenP2.dart';
import 'package:apppersonaltrainer/screens/student/student_screenP3.dart';
import 'package:apppersonaltrainer/screens/student/student_screenP4.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'models/gym_manager.dart';
import 'models/plan.dart';
import 'models/planManager.dart';
import 'models/user_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => CalendarManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, StudentManager>(
          create: (_) => StudentManager(),
          lazy: false,
          update: (_, userManager, studentManager) {
            return studentManager..updateStudent(userManager);
          },
        ),
        ChangeNotifierProxyProvider<UserManager, GymManager>(
          create: (_) => GymManager(),
          lazy: false,
          update: (_, userManager, gymManager) {
            return gymManager..updateGym(userManager);
          },
        ),
        ChangeNotifierProxyProvider<UserManager, PlanManager>(
          create: (_) => PlanManager(),
          lazy: false,
          update: (_, userManager, planManager) {
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
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case '/signup':
              return MaterialPageRoute(builder: (_) => SignUpScreen());
            case '/edit_student':
              return MaterialPageRoute(
                  builder: (_) => StudentScreen(settings.arguments as Student));
            case '/create_student':
              return MaterialPageRoute(
                  builder: (_) => StudentScreenP1());
            case '/edit_plan':
              return MaterialPageRoute(
                  builder: (_) => PlanScreen(settings.arguments as Plan));
            case '/edit_gym':
              return MaterialPageRoute(
                  builder: (_) => GymScreen(settings.arguments as Gym));
            case '/create_student_p2':
              return MaterialPageRoute(
                builder: (_) => StudentScreenP2(settings.arguments as Student));
            case '/create_student_p3':
              return MaterialPageRoute(
                  builder: (_) => StudentScreenP3(settings.arguments as Student));
            case '/create_student_p4':
              return MaterialPageRoute(
                  builder: (_) => StudentScreenP4(settings.arguments as Student));
            case 'signup_p2':
              return MaterialPageRoute(
                  builder: (_) => SignUpScreenP2(settings.arguments as User));
            case '/base':
            default:
              return MaterialPageRoute(builder: (_) => BaseScreen());
          }
        },
      ),
    );
  }
}
