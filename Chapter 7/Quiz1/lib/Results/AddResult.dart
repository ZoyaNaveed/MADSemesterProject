import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:flutter_application_1/Results/resultsMainScreen.dart';
import 'package:http/http.dart' as http;

class AddResults extends StatefulWidget {
  const AddResults({super.key});

  @override
  State<AddResults> createState() => _AddResultsState();
}

class _AddResultsState extends State<AddResults> {
  final TextEditingController studentController = TextEditingController();
  final TextEditingController teacherController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  String selectedCourseCode = '';
  List<String> courseCodes = [];
  String selectedCourseName = '';
  List<String> courseNames = [];

  @override
  void initState() {
    super.initState();
    fetchCourseCodes();
    fetchCourseNames();
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

  Future<void> fetchCourseNames() async {
    final response = await http.get(Uri.parse(coursesurl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // Use a Set to ensure unique course codes
      Set<String> uniqueCourseNames =
          Set<String>.from(data.map((json) => json['name'].toString()));

      print(
          'Original course names: ${data.map((json) => json['name'].toString()).toList()}');
      print('Unique course names: $uniqueCourseNames');

      setState(() {
        courseNames = uniqueCourseNames.toList();
      });
    } else {
      // Handle error
      print('Failed to load course names: ${response.statusCode}');
    }
  }

  Future<void> _addResults() async {
    try {
      if (teacherController.text.isNotEmpty &&
          gradeController.text.isNotEmpty &&
          selectedCourseCode.isNotEmpty &&
          selectedCourseName.isNotEmpty &&
          remarksController.text.isNotEmpty &&
          studentController.text.isNotEmpty) {
        var regBody = {
          "courseName": selectedCourseName,
          "courseCode": selectedCourseCode,
          "student": studentController.text,
          "teacher": teacherController.text,
          "grade": gradeController.text,
          "remarks": remarksController.text,
        };
        var response = await http.post(Uri.parse(resultsUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regBody));
        if (response.statusCode == 201) {
          // Course added successfully
          print('Results added successfully');
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => ResultsOptionsPage()));
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
        title: Text('Upload results'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedCourseName.isNotEmpty ? selectedCourseName : null,
              onChanged: (value) {
                setState(() {
                  selectedCourseName = value!;
                });
              },
              items: courseNames.map((code) {
                return DropdownMenuItem<String>(
                  value: code,
                  child: Text(code),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Select Course Name'),
            ),
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
            SizedBox(height: 16.0),
            TextField(
              controller: studentController,
              decoration: InputDecoration(labelText: 'Student Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: teacherController,
              decoration: InputDecoration(labelText: 'Teacher Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: gradeController,
              decoration: InputDecoration(labelText: 'Grade'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: remarksController,
              decoration: InputDecoration(labelText: 'Remarks'),
            ),
            //DROP DOWN BOX

            //--------------------------------
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _addResults,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                minimumSize: MaterialStateProperty.all<Size>(
                    Size(200, 50)), // Adjust width and height as needed
              ),
              child: Text(
                'Add Results',
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
