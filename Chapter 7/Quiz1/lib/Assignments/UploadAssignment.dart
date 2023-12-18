import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Assignments/assignments.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class AssignmentForm extends StatefulWidget {
  @override
  _AssignmentFormState createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _courseCodeController;
  late TextEditingController _deadlineController;
  late File _selectedFile;
  String selectedCourseCode = '';
  List<String> courseCodes = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _courseCodeController = TextEditingController();
    _deadlineController = TextEditingController();
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

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      String description = _descriptionController.text;
      String courseCode = _courseCodeController.text;
      String deadline = _deadlineController.text;

      // Assuming you have an API endpoint to handle assignment creation
      var apiUrl = Uri.parse(assignmentsUrl);

      var request = http.MultipartRequest("POST", apiUrl)
        ..fields['title'] = title
        ..fields['description'] = description
        ..fields['courseCode'] = selectedCourseCode
        ..fields['deadline'] = deadline
        ..files.add(http.MultipartFile.fromBytes(
            'content', await _selectedFile.readAsBytes(),
            filename: _selectedFile.path.split("/").last));

      var response = await request.send();

      if (response.statusCode == 201) {
        // Assignment created successfully
        print("Assignment created successfully");
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => AssignmentsPage()));
      } else {
        // Handle error
        print(
            "Failed to create assignment. Status code: ${response.statusCode}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Assignment'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16.0),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value:
                    selectedCourseCode.isNotEmpty ? selectedCourseCode : null,
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
              TextFormField(
                controller: _deadlineController,
                decoration: InputDecoration(labelText: 'Deadline'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a deadline';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickFile,
                child: Text('Select File'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  minimumSize: MaterialStateProperty.all<Size>(
                      Size(200, 50)), // Adjust width and height as needed
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  minimumSize: MaterialStateProperty.all<Size>(
                      Size(200, 50)), // Adjust width and height as needed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
