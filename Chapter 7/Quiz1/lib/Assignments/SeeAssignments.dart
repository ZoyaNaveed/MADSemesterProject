import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:http/http.dart' as http;

class SeeAssignments extends StatefulWidget {
  const SeeAssignments({super.key});

  @override
  State<SeeAssignments> createState() => _SeeAssignmentsState();
}

class _SeeAssignmentsState extends State<SeeAssignments> {
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

  Future<void> deleteassignment(String notsUrl, String notsId) async {
    final response = await http.delete(Uri.parse('$notsUrl/$notsId'));

    if (response.statusCode == 200) {
      fetchassignsData();

      print('Assignment deleted successfully');
    } else {
      throw Exception('Failed to delete Assignment: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('All Notifications'),
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
                            deleteassignment(assignmentsUrl, numbers[index].id);
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
