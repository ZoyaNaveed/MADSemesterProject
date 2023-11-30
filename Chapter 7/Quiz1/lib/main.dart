import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Assignments/AddAssignment.dart';
import 'package:flutter_application_1/Assignments/SeeAssignments.dart';
import 'package:flutter_application_1/Assignments/assignments.dart';
import 'package:flutter_application_1/CoursesScreen/AddCourses.dart';
import 'package:flutter_application_1/CoursesScreen/courses.dart';
import 'package:flutter_application_1/CoursesScreen/seeCourses.dart';
import 'package:flutter_application_1/NotificationsScreens/NewNotifications.dart';
import 'package:flutter_application_1/NotificationsScreens/SeeNotifications.dart';
import 'package:flutter_application_1/NotificationsScreens/notifications.dart';
import 'package:flutter_application_1/Results/AddResult.dart';
import 'package:flutter_application_1/Results/ShowResults.dart';
import 'package:flutter_application_1/Results/resultsMainScreen.dart';
//import 'package:flutter_application_1/Screens/loginScreen.dart';
import 'package:flutter_application_1/Screens/mainScreen.dart';
import 'package:flutter_application_1/StudentScreens/StudentNotifications.dart';
import 'package:flutter_application_1/StudentScreens/studentResults.dart';
import 'package:flutter_application_1/StudentScreens/studentmainScreen.dart';
//import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  final client = HttpClient();
  client.connectionTimeout = Duration(seconds: 10);
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    token: prefs.getString('token'),
  ));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({
    @required this.token,
    Key? key,
  }) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Starter Template',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/home': (context) => HomePage(),
          //'/profile': (context) => ProfilePage(),
          '/courses': (context) => CoursesPage(),
          '/seeCourses': (context) => AllCourses(),
          '/addCourse': (context) => AddCourses(),
          '/nots': (context) => NotificationsPage(),
          '/seeNots': (context) => SeeNotifications(),
          '/newNots': (context) => AddNotificationsPage(),
          '/assignments': (context) => AssignmentsPage(),
          '/newAssignment': (context) => AddAssignmentsPage(),
          '/seeAssignment': (context) => SeeAssignments(),
          //'results': (context) => ResultsPage(),
          '/home2': (context) => StudentMainScreen(),
          '/studentnots': (context) => AllNotifications(),
          //'/studentresults': (context) => StudentResults(),
          '/blahblah': (context) => ResultsOptionsPage(),
          '/addresults': (context) => AddResults(),
          '/seeresults': (context) => SeeResultsPage(),
        },
        home: StudentMainScreen(
          token: token,
        )); // (token != null && JwtDecoder.isExpired(token) == false)
    //     ? HomePage(token: token)
    //     : LoginPage());
  }
}
