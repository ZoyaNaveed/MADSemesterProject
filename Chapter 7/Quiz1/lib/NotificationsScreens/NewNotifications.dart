import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:flutter_application_1/NotificationsScreens/notifications.dart';
import 'package:http/http.dart' as http;

class AddNotificationsPage extends StatefulWidget {
  @override
  _AddNotificationsPageState createState() => _AddNotificationsPageState();
}

class _AddNotificationsPageState extends State<AddNotificationsPage> {
  final TextEditingController headerController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  String selectedCourseCode = '';
  List<String> courseCodes = [];

  @override
  void initState() {
    super.initState();
    fetchCourseCodes();
  }

  Future<void> fetchCourseCodes() async {
    final response = await http.get(Uri.parse(coursesurl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // Use a Set to ensure unique course codes
      Set<String> uniqueCourseCodes =
          Set<String>.from(data.map((json) => json['code'].toString()));

      print(
          'Original course codes: ${data.map((json) => json['code'].toString()).toList()}');
      print('Unique course codes: $uniqueCourseCodes');

      setState(() {
        courseCodes = uniqueCourseCodes.toList();
      });
    } else {
      // Handle error
      print('Failed to load course codes: ${response.statusCode}');
    }
  }

  Future<void> _addNotification() async {
    try {
      if (headerController.text.isNotEmpty &&
          bodyController.text.isNotEmpty &&
          selectedCourseCode.isNotEmpty) {
        var regBody = {
          "header": headerController.text,
          "body": bodyController.text,
          "courseCode": selectedCourseCode
        };
        var response = await http.post(Uri.parse(notsUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regBody));
        if (response.statusCode == 201) {
          // Course added successfully
          print('Notification added successfully');
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => NotificationsPage()));
        }
      }
    } catch (error) {
      // Handle any exceptions that occur during the HTTP request
      print('Error adding notification: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('New Notification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: headerController,
              decoration: InputDecoration(labelText: 'Notification Header'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(labelText: 'Notification Body'),
            ),
            //DROP DOWN BOX
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedCourseCode.isNotEmpty ? selectedCourseCode : null,
              onChanged: (value) {
                setState(() {
                  selectedCourseCode = value!;
                });
              },
              items: courseCodes.map((code) {
                return DropdownMenuItem<String>(
                  value: code,
                  child: Text(code),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Select Course Code'),
            ),

            //--------------------------------
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _addNotification,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                minimumSize: MaterialStateProperty.all<Size>(
                    Size(200, 50)), // Adjust width and height as needed
              ),
              child: Text(
                'Add Notification',
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 18, // Text size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
