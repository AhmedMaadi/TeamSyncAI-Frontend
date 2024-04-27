import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:teamsyncai/screens/dashboardscreen/project2.dart';

class ProjectFirst extends StatefulWidget {
  const ProjectFirst({Key? key, required String email});

  @override
  _ProjectFirstState createState() => _ProjectFirstState();
}

class _ProjectFirstState extends State<ProjectFirst> {
  DateTime? startDate;
  DateTime? endDate;
  String projectName = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creating The Project'),
        backgroundColor: const Color(0xFFE89F16),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter project name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.0)),
                  ),
                  onChanged: (value) {
                    projectName = value;
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  'Start Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _selectDate(context, 'start');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ), backgroundColor: const Color(0xFFFFFFFF),
                  ),
                  child: Text(startDate != null ? ' ${DateFormat('yyyy-MM-dd').format(startDate!)}' : 'Select Start Date'),
                ),
                const SizedBox(height: 30),
                const Text(
                  'End Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _selectDate(context, 'end');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ), backgroundColor: const Color(0xFFFCFCFC),
                  ),
                  child: Text(endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : 'Select End Date'),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter project description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    description = value;
                  },
                ),
                const SizedBox(height: 90),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectSecond(
                      projectName: projectName,
                      startDate: startDate,
                      endDate: endDate,
                      description: description,
                    )));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE89F16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      )
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.day,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFFE89F16),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE89F16),
              onPrimary: Colors.white,
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    setState(() {
      if (type == 'start') {
        startDate = picked;
      } else if (type == 'end') {
        endDate = picked;
      }
    });
  }

}