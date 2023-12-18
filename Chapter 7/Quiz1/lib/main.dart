import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Assignments/SeeAssignments.dart';
import 'package:flutter_application_1/Assignments/UploadAssignment.dart';
import 'package:flutter_application_1/Assignments/assignments.dart';
import 'package:flutter_application_1/CoursesScreen/AddCourses.dart';
import 'package:flutter_application_1/CoursesScreen/courses.dart';
import 'package:flutter_application_1/CoursesScreen/seeCourses.dart';
import 'package:flutter_application_1/Fees/SeeAllFees.dart';
import 'package:flutter_application_1/Fees/UploadFees.dart';
import 'package:flutter_application_1/Fees/fees.dart';
import 'package:flutter_application_1/NotificationsScreens/NewNotifications.dart';
import 'package:flutter_application_1/NotificationsScreens/SeeNotifications.dart';
import 'package:flutter_application_1/NotificationsScreens/notifications.dart';
import 'package:flutter_application_1/Results/AddResult.dart';
import 'package:flutter_application_1/Results/ShowResults.dart';
import 'package:flutter_application_1/Results/resultsMainScreen.dart';
import 'package:flutter_application_1/Screens/mainScreen.dart';
import 'package:flutter_application_1/StudentScreens/Registercourse.dart';
import 'package:flutter_application_1/StudentScreens/StudentAssignment.dart';
import 'package:flutter_application_1/StudentScreens/StudentFees.dart';
import 'package:flutter_application_1/StudentScreens/StudentNotifications.dart';
import 'package:flutter_application_1/StudentScreens/studentResults.dart';
import 'package:flutter_application_1/StudentScreens/studentmainScreen.dart';
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
          '/newAssignment': (context) => AssignmentForm(),
          '/seeAssignment': (context) => SeeAssignments(),
          '/home2': (context) => StudentMainScreen(),
          '/studentnots': (context) => AllNotifications(),
          '/blahblah': (context) => ResultsOptionsPage(),
          '/addresults': (context) => AddResults(),
          '/seeresults': (context) => SeeResultsPage(),
          '/fees': (context) => FeesPage(),
          '/seeFees': (context) => SeeFees(),
          '/uploadFees': (context) => UploadFees(),
          '/studentassignments': (context) => StudentAssignmentPage(),
          '/studentfees': (context) => StudentFees(),
        },
        home: StudentMainScreen(
          token: token,
        )); // (token != null && JwtDecoder.isExpired(token) == false)
    //     ? HomePage(token: token)
    //     : LoginPage());
  }
}
