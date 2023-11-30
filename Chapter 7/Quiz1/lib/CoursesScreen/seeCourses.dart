import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:http/http.dart' as http;

class AllCourses extends StatefulWidget {
  const AllCourses({super.key});

  @override
  State<AllCourses> createState() => _AllCoursesState();
}

class _AllCoursesState extends State<AllCourses> {
  List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(coursesurl));

    if (response.statusCode == 200) {
      // Parse the JSON data
      List<dynamic> data = json.decode(response.body);
      List<Course> fetchedCourses =
          data.map((json) => Course.fromJson(json)).toList();

      setState(() {
        courses = fetchedCourses;
      });
    } else {
      // Handle error
      print('Failed to load data: ${response.statusCode}');
    }
  }

  Future<void> deleteCourse(String courseurl, String courseId) async {
    final response = await http.delete(Uri.parse('$courseurl/$courseId'));

    if (response.statusCode == 200) {
      fetchData();
      print('Course deleted successfully');
    } else {
      throw Exception('Failed to delete course: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('All Courses'),
        ),
        body: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courses[index].courseName,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Course Code: ${courses[index].courseCode}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Teacher Assigned: ${courses[index].teacherName}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    // Add the Delete button
                    ElevatedButton(
                      onPressed: () {
                        // Call a function to handle course deletion
                        deleteCourse(coursesurl, courses[index].id);
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
                  ],
                ),
              ),
            );
          },
        ));
  }
}

class Course {
  final String id;
  final String courseName;
  final String courseCode;
  final String teacherName;

  Course(
      {required this.id,
      required this.courseName,
      required this.courseCode,
      required this.teacherName});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'],
      courseName: json['name'],
      courseCode: json['code'],
      teacherName: json['teacher'],
    );
  }
}
