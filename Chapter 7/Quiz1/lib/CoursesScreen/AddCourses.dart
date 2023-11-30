import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/CoursesScreen/courses.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:http/http.dart' as http;

class AddCourses extends StatefulWidget {
  const AddCourses({super.key});

  @override
  State<AddCourses> createState() => _AddCoursesState();
}

class _AddCoursesState extends State<AddCourses> {
  TextEditingController _courseNameController = TextEditingController();
  TextEditingController _courseCodeController = TextEditingController();
  TextEditingController _teacherController = TextEditingController();

  Future<void> _addCourse() async {
    try {
      if (_courseNameController.text.isNotEmpty &&
          _courseCodeController.text.isNotEmpty &&
          _teacherController.text.isNotEmpty) {
        var regBody = {
          "name": _courseNameController.text,
          "code": _courseCodeController.text,
          "teacher": _teacherController.text
        };
        var response = await http.post(Uri.parse(coursesurl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regBody));
        if (response.statusCode == 201) {
          // Course added successfully
          print('Course added successfully');
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => CoursesPage()));
        }
      }
    } catch (error) {
      // Handle any exceptions that occur during the HTTP request
      print('Error adding course: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Add Courses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _courseNameController,
              decoration: InputDecoration(labelText: 'Course Name'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _courseCodeController,
              decoration: InputDecoration(labelText: 'Course Code'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _teacherController,
              decoration: InputDecoration(labelText: 'Teacher'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addCourse,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                minimumSize: MaterialStateProperty.all<Size>(
                    Size(200, 50)), // Adjust width and height as needed
              ),
              child: Text(
                'Add Course',
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
