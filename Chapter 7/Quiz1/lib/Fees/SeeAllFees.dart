import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:http/http.dart' as http;

class SeeFees extends StatefulWidget {
  const SeeFees({super.key});

  @override
  State<SeeFees> createState() => _SeeFeesState();
}

class _SeeFeesState extends State<SeeFees> {
  List<Fees> numbers = [];

  @override
  void initState() {
    super.initState();
    fetchfeesData();
  }

  Future<void> fetchfeesData() async {
    final response = await http.get(Uri.parse(feesUrl));

    if (response.statusCode == 200) {
      // Parse the JSON data
      List<dynamic> data = json.decode(response.body);
      List<Fees> fetchedfees = data.map((json) => Fees.fromJson(json)).toList();

      setState(() {
        numbers = fetchedfees;
      });
    } else {
      // Handle error
      print('Failed to load data: ${response.statusCode}');
    }
  }

  Future<void> deleteFees(String notsUrl, String notsId) async {
    final response = await http.delete(Uri.parse('$notsUrl/$notsId'));

    if (response.statusCode == 200) {
      fetchfeesData();

      print('Fees deleted successfully');
    } else {
      throw Exception('Failed to delete Fees: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('All Fee Slips'),
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
                      numbers[index].session,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
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
                            deleteFees(feesUrl, numbers[index].id);
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
                  ],
                ),
              ),
            );
          },
        ));
  }
}

class Fees {
  final String id;
  final String session;
  final String deadline;
  final String content;

  Fees(
      {required this.id,
      required this.session,
      required this.deadline,
      required this.content});

  factory Fees.fromJson(Map<String, dynamic> json) {
    return Fees(
        id: json['_id'],
        session: json['session'],
        deadline: json['deadline'],
        content: json['content']);
  }
}
