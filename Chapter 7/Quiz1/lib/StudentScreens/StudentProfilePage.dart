import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/loginScreen.dart';

class StudentProfilePage extends StatelessWidget {
  final String username;
  final String email;

  // You can add more fields like 'role' as needed

  StudentProfilePage({required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80.0,
                // Add the user's profile picture here
                backgroundImage: AssetImage('assets/images/pp.jpg'),
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 20.0),
              _buildProfileInfo('Name', username),
              _buildProfileInfo('Email', email),
              _buildProfileInfo('Role', 'Student'),
              SizedBox(height: 30.0),
              _buildActionButton(context, 'Log Out', Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, label, Color buttonColor) {
    return ElevatedButton(
      onPressed: () {
        // Handle button tap
        if (label == 'Log Out') {
          // Add logic for logging out
          logout(context);
        }
      },
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 18.0, color: Colors.white),
      ),
    );
  }

  void logout(BuildContext context) {
    // Add any additional logic for user logout (e.g., clear user session)

    // Navigate back to the login page
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
