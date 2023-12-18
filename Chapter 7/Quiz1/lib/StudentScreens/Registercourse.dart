import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  List<String> courseNames = []; // List to store course names
  String selectedCourse = ''; // Selected course from dropdown
  TextEditingController semesterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch course names when the page is loaded
    fetchCourseNames();
  }

  Future<void> fetchCourseNames() async {
    final response = await http.get(Uri.parse(coursesurl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // Use a Set to ensure unique course codes
      Set<String> uniqueCourseCodes =
          Set<String>.from(data.map((json) => json['name'].toString()));

      print(
          'Original course codes: ${data.map((json) => json['name'].toString()).toList()}');
      print('Unique course codes: $uniqueCourseCodes');

      setState(() {
        courseNames = uniqueCourseCodes.toList();
      });
    } else {
      // Handle error
      print('Failed to load course codes: ${response.statusCode}');
    }
  }

  Future<void> register() async {
    // TODO: Replace the URL with your actual API endpoint for registration
    final response = await http.post(
      registerCourses as Uri,
      body: jsonEncode({
        'course': selectedCourse,
        'semester': semesterController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Registration successful
      print('Registration successful');
      // You can add more logic here, such as navigation to a success page.
    } else {
      // Registration failed
      print('Registration failed');
      // You can handle errors here, such as displaying an error message.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Registration'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedCourse.isNotEmpty ? selectedCourse : null,
              onChanged: (value) {
                setState(() {
                  selectedCourse = value!;
                });
              },
              items: courseNames.map((code) {
                return DropdownMenuItem<String>(
                  value: code,
                  child: Text(code),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Select Course Code'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: semesterController,
              decoration: InputDecoration(
                labelText: 'Semester',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Validate the selected course and semester before registration
                if (selectedCourse.isNotEmpty &&
                    semesterController.text.isNotEmpty) {
                  register();
                } else {
                  // Display an error message if required fields are not filled
                  // You can customize this part based on your needs
                  print('Please fill all fields');
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                minimumSize: MaterialStateProperty.all<Size>(
                    Size(200, 50)), // Adjust width and height as needed
              ),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
