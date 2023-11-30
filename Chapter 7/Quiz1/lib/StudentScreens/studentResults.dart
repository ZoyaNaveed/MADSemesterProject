import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:http/http.dart' as http;

class StudentResultsPage extends StatefulWidget {
  final String username;

  StudentResultsPage({required this.username});
  @override
  State<StudentResultsPage> createState() => _StudentResultsPageState();
}

class _StudentResultsPageState extends State<StudentResultsPage> {
  List<Results> UserResults = [];

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  Future<void> fetchResults() async {
    final response = await http.get(Uri.parse(resultsUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResults = json.decode(response.body);
      List<Results> fetchedResults = jsonResults
          .map((json) => Results.fromJson(json))
          .where((result) => result.student == widget.username)
          .toList();

      UserResults = fetchedResults;
    } else {
      throw Exception('Failed to load results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Results'),
        ),
        body: ListView.builder(
          itemCount: UserResults.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserResults[index].student,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      ' ${UserResults[index].courseName}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      ' ${UserResults[index].courseCode}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      ' ${UserResults[index].grade}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      ' ${UserResults[index].teacher}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      ' ${UserResults[index].remarks}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),

                    // Add the Delete button
                  ],
                ),
              ),
            );
          },
        ));
  }
}

class Results {
  final String id;
  final String courseName;
  final String courseCode;
  final String student;
  final String teacher;
  final String grade;
  final String remarks;

  Results(
      {required this.id,
      required this.courseName,
      required this.courseCode,
      required this.student,
      required this.teacher,
      required this.grade,
      required this.remarks});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      id: json['_id'],
      courseName: json['courseName'],
      courseCode: json['courseCode'],
      student: json['student'],
      teacher: json['teacher'],
      grade: json['grade'],
      remarks: json['remarks'],
    );
  }
}
