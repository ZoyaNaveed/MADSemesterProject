import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:flutter_application_1/Fees/fees.dart';
import 'package:http/http.dart' as http;

class UploadFees extends StatefulWidget {
  const UploadFees({super.key});

  @override
  State<UploadFees> createState() => _UploadFeesState();
}

class _UploadFeesState extends State<UploadFees> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _sessionController;
  late TextEditingController _deadlineController;
  late File _selectedFile;
  String selectedCourseCode = '';
  List<String> courseCodes = [];

  @override
  void initState() {
    super.initState();
    _sessionController = TextEditingController();
    _deadlineController = TextEditingController();
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
      String session = _sessionController.text;
      String deadline = _deadlineController.text;

      // Assuming you have an API endpoint to handle assignment creation
      var apiUrl = Uri.parse(feesUrl);

      var request = http.MultipartRequest("POST", apiUrl)
        ..fields['session'] = session
        ..fields['deadline'] = deadline
        ..files.add(http.MultipartFile.fromBytes(
            'content', await _selectedFile.readAsBytes(),
            filename: _selectedFile.path.split("/").last));

      var response = await request.send();

      if (response.statusCode == 201) {
        // Assignment created successfully
        print("Fees Uploaded successfully");
        Navigator.push(context, MaterialPageRoute(builder: (c) => FeesPage()));
      } else {
        // Handle error
        print("Failed to upload Fees. Status code: ${response.statusCode}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Fees'),
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
                controller: _sessionController,
                decoration: InputDecoration(labelText: 'Session'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a session';
                  }
                  return null;
                },
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
