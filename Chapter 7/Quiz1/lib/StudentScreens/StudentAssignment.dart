import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class StudentAssignmentPage extends StatefulWidget {
  const StudentAssignmentPage({super.key});

  @override
  State<StudentAssignmentPage> createState() => _StudentAssignmentPageState();
}

class _StudentAssignmentPageState extends State<StudentAssignmentPage> {
  List<Assignment> numbers = [];

  @override
  void initState() {
    super.initState();
    fetchassignsData();
  }

  Future<void> fetchassignsData() async {
    final response = await http.get(Uri.parse(assignmentsUrl));

    if (response.statusCode == 200) {
      // Parse the JSON data
      List<dynamic> data = json.decode(response.body);
      List<Assignment> fetchedassigns =
          data.map((json) => Assignment.fromJson(json)).toList();

      setState(() {
        numbers = fetchedassigns;
      });
    } else {
      // Handle error
      print('Failed to load data: ${response.statusCode}');
    }
  }

  Future<void> downloadAssignment(String assignmentId) async {
    final response =
        await http.get(Uri.parse('$assignmentsUrl/$assignmentId/download'));

    if (response.statusCode == 200) {
      // Get the documents directory using path_provider
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath =
          '${appDocDir.path}/downloaded_file.pdf'; // You can change the file name and extension

      // Write the file
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Open the file using the default platform mechanism
      OpenFile.open(filePath);
    } else {
      // Handle error
      print('Failed to download file: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('All Assignments'),
        ),
        body: ListView.builder(
          itemCount: numbers.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      numbers[index].title,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      ' ${numbers[index].description}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      ' ${numbers[index].CourseCode}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      ' ${numbers[index].deadline}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    // Add the Delete button
                    Row(
                      children: [
                        SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            // Call a function to handle course deletion
                            downloadAssignment(numbers[index].id);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Download Assignment',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

class Assignment {
  final String id;
  final String title;
  final String description;
  final String CourseCode;
  final String deadline;
  final String content;

  Assignment(
      {required this.id,
      required this.title,
      required this.description,
      required this.CourseCode,
      required this.deadline,
      required this.content});

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
        id: json['_id'],
        title: json['title'],
        description: json['description'],
        CourseCode: json['courseCode'],
        deadline: json['deadline'],
        content: json['content']);
  }
}
