import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teamsyncai/screens/screenrec/AddReclamation%20.dart';
import 'dart:convert';
import 'package:teamsyncai/model/reclamation.dart';


class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<Reclamation> feedbacks = [];

  Future<void> fetchFeedback() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.56.1:48183/reclamation/type/feedback'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print("Received data: $data");

        setState(() {
          feedbacks = data.map((item) => Reclamation(
            title: item['title'] ?? '',
            status: item['status'] ?? '',
            description: item['description'] ?? '',
            date: DateTime.parse(item['date']),
            type: item['type'] ?? '',
          )).toList();
        });
      } else {
        print("Failed to load data: ${response.statusCode}");
        throw Exception('Failed to load data'); // Gestion des erreurs de chargement
      }
    } catch (e) {
      print("Network error: $e");
      throw Exception('Network error'); // Gestion des erreurs réseau
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedbacks'),
      ),
      body: Center(
        child: feedbacks.isEmpty
            ? const Text('No feedback found')
            : ListView.builder(
                itemCount: feedbacks.length,
                itemBuilder: (context, index) {
                  final feedback = feedbacks[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feedback.title,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(feedback.description),
                              ],
                            ),
                          ),
                          _buildStatusWidget(feedback.status) // Helper function for status widget
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReclamation()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      ),
    );
  }

  Widget _buildStatusWidget(String status) {
    Color backgroundColor;
    switch (status.toLowerCase()) {
      case 'in progress':
        backgroundColor = Colors.orange;
        break;
      case 'accepted':
        backgroundColor = Colors.green;
        break;
      case 'rejected':
        backgroundColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Row(
      children: [
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        const SizedBox(width: 5.0),
        Text(status),
        const SizedBox(width: 5.0),
               IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            // Implement deletion logic here
            // (e.g., call an API endpoint or show confirmation dialog)
    print('Delete button pressed for feedback'); // Fixed quotation mark
          },
        ),
      ],
    );
  }
}