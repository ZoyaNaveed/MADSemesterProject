import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:http/http.dart' as http;

class AddAssignmentsPage extends StatefulWidget {
  const AddAssignmentsPage({super.key});

  @override
  State<AddAssignmentsPage> createState() => _AddAssignmentsPageState();
}

class _AddAssignmentsPageState extends State<AddAssignmentsPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionConroller = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

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

  void addassignment() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Add Assignment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionConroller,
              decoration: InputDecoration(labelText: 'Description'),
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
              controller: deadlineController,
              decoration: InputDecoration(labelText: 'Deadline'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addassignment,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                minimumSize: MaterialStateProperty.all<Size>(
                    Size(200, 50)), // Adjust width and height as needed
              ),
              child: Text(
                'Select PDF file',
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 18, // Text size
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Text(
            //   'Selected File: $filePath',
            //   style: TextStyle(fontSize: 16.0),
            // ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: addassignment,
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
