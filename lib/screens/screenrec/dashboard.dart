import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final String reportType;

  const Dashboard({required this.reportType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reportType),
      ),
      body: const Center(
        child: Text(
          'Voici mon dashboard',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}