import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:http/http.dart' as http;

class AllNotifications extends StatefulWidget {
  const AllNotifications({super.key});

  @override
  State<AllNotifications> createState() => _AllNotificationsState();
}

class _AllNotificationsState extends State<AllNotifications> {
  List<Nots> numbers = [];

  @override
  void initState() {
    super.initState();
    fetchNotsData();
  }

  Future<void> fetchNotsData() async {
    final response = await http.get(Uri.parse(notsUrl));

    if (response.statusCode == 200) {
      // Parse the JSON data
      List<dynamic> data = json.decode(response.body);
      List<Nots> fetchedNots = data.map((json) => Nots.fromJson(json)).toList();

      setState(() {
        numbers = fetchedNots;
      });
    } else {
      // Handle error
      print('Failed to load data: ${response.statusCode}');
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
                      numbers[index].header,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      ' ${numbers[index].body}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      ' ${numbers[index].CourseCode}',
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

class Nots {
  final String id;
  final String header;
  final String body;
  final String CourseCode;

  Nots(
      {required this.id,
      required this.header,
      required this.body,
      required this.CourseCode});

  factory Nots.fromJson(Map<String, dynamic> json) {
    return Nots(
      id: json['_id'],
      header: json['header'],
      body: json['body'],
      CourseCode: json['courseCode'],
    );
  }
}
