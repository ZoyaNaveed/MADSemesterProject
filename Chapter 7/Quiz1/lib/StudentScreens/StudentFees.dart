import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/config.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class StudentFees extends StatefulWidget {
  const StudentFees({super.key});

  @override
  State<StudentFees> createState() => _StudentFeesState();
}

class _StudentFeesState extends State<StudentFees> {
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

  Future<void> downloadFeeSlip(String assignmentId) async {
    final response =
        await http.get(Uri.parse('$feesUrl/$assignmentId/download'));

    if (response.statusCode == 200) {
      // Get the documents directory using path_provider
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath =
          '${appDocDir.path}/fee_slip.png'; // You can change the file name and extension

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
                            //deleteFees(feesUrl, numbers[index].id);
                            downloadFeeSlip(numbers[index].id);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Download Challan',
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
