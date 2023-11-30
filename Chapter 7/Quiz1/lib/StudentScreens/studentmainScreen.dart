import 'package:flutter/material.dart';
import 'package:flutter_application_1/StudentScreens/StudentProfilePage.dart';
import 'package:flutter_application_1/StudentScreens/studentResults.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class StudentMainScreen extends StatefulWidget {
  final token;
  const StudentMainScreen({this.token, super.key});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  late String email;
  late String username;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);

    username = jwtDecodeToken['username'];
    email = jwtDecodeToken['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$username Home Page'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Profile Section
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage("assets/images/pp.jpg"),
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 16.0),
            Text(
              username, // Replace with actual user name
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              email, // Replace with actual roll number
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20),

            // Big Card-like Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BigButtonCard(
                  buttonText: 'Profile',
                  icon: Icons.account_circle,
                  route: '/profile',
                  username: username, // Pass username to BigButtonCard
                  email: email, // Pass email to BigButtonCard
                ),
                BigButtonCard(
                  buttonText: 'Courses',
                  icon: Icons.book,
                  route: '/studentcourses',
                  username: username,
                  email: email,
                ),
              ],
            ),
            SizedBox(height: 20),

            // Big Card-like Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BigButtonCard(
                  buttonText: 'Notifications',
                  icon: Icons.notifications,
                  route: '/studentnots',
                  username: username, // Pass username to BigButtonCard
                  email: email, // Pass email to BigButtonCard
                ),
                BigButtonCard(
                  buttonText: 'Assignments',
                  icon: Icons.assignment,
                  route: '/studentassignments',
                  username: username,
                  email: email,
                ),
              ],
            ),
            SizedBox(height: 20),

            // Big Card-like Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BigButtonCard(
                  buttonText: 'Fees',
                  icon: Icons.money,
                  route: '/studentfees',
                  username: username, // Pass username to BigButtonCard
                  email: email, // Pass email to BigButtonCard
                ),
                BigButtonCard(
                  buttonText: 'Results',
                  icon: Icons.poll,
                  route: '/studentresults',
                  username: username,
                  email: email,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BigButtonCard extends StatelessWidget {
  final String buttonText;
  final IconData icon;
  final String route;
  final String username; // Add username parameter
  final String email; // Add email parameter

  BigButtonCard(
      {required this.buttonText,
      required this.icon,
      required this.route,
      required this.username,
      required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          // Pass username and email when navigating to the profile page
          if (route == '/profile') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentProfilePage(
                  username: username,
                  email: email,
                ),
              ),
            );
          }
          if (route == '/studentresults') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentResultsPage(
                  username: username,
                ),
              ),
            );
          } else {
            Navigator.pushNamed(context, route);
          }
        },
        child: Container(
          color: Colors.black,
          width: 150,
          height: 150,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text(
                buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
