import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:http/http.dart' as http;

class SeeResultsPage extends StatefulWidget {
  const SeeResultsPage({super.key});

  @override
  State<SeeResultsPage> createState() => _SeeResultsPageState();
}

class _SeeResultsPageState extends State<SeeResultsPage> {
  List<Results> results = [];

  @override
  void initState() {
    super.initState();
    fetchresultsData();
  }

  Future<void> fetchresultsData() async {
    final response = await http.get(Uri.parse(resultsUrl));

    if (response.statusCode == 200) {
      // Parse the JSON data
      List<dynamic> data = json.decode(response.body);
      List<Results> fetchedData =
          data.map((json) => Results.fromJson(json)).toList();

      setState(() {
        results = fetchedData;
      });
    } else {
      // Handle error
      print('Failed to load data: ${response.statusCode}');
    }
  }

  Future<void> deleteResult(String resultsUrl, String rId) async {
    final response = await http.delete(Uri.parse('$resultsUrl/$rId'));

    if (response.statusCode == 200) {
      fetchresultsData();

      print('Result deleted successfully');
    } else {
      throw Exception('Failed to delete Result: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('All Results'),
        ),
        body: ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      results[index].student,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      ' ${results[index].courseName}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      ' ${results[index].courseCode}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      ' ${results[index].grade}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      ' ${results[index].teacher}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      ' ${results[index].remarks}',
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
                            deleteResult(resultsUrl, results[index].id);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            // Call a function to handle course deletion
                            //deleteCourse(notsUrl, numbers[index].id);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey, // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
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
