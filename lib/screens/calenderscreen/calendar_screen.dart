import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:teamsyncai/model/calanderproject.dart';




class CalendarScreen extends StatefulWidget {
  final String email;

  const CalendarScreen({required this.email});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarView _currentView = CalendarView.month;
  List<Project> _projects = [];
  Project? _selectedProject;

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  // Méthode fetchProjects() pour récupérer les projets depuis une API
  Future<void> fetchProjects() async {
    try {
      final Uri url =
          Uri.parse('http://192.168.1.15:3000/user/getAllProjects');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final projectsData = json.decode(response.body);
        List<Project> projects = [];
        for (var projectData in projectsData) {
          if (projectData['start_date'] != null &&
              projectData['end_date'] != null &&
              projectData['modules'] != null &&
              projectData['modules'] is List &&
              projectData['modules'].isNotEmpty &&
              projectData['total_duration'] != null &&
              projectData['total_duration'] is int) {
            projects.add(Project.fromJson(projectData));
          } else {
            print('Incomplete project data: $projectData');
          }
        }

        setState(() {
          _projects = projects;
        });
      } else {
        throw Exception('Failed to fetch projects');
      }
    } catch (error) {
      print(error);
    }
  }

  // Méthode pour construire le widget d'un événement dans le calendrier
  Widget _getAppointmentWidget(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final DateTime startTime = details.date!;

    if (_selectedProject == null || _projects.isEmpty) {
      return Container();
    }

    bool isEventDate = false;
    for (var module in _selectedProject!.modules) {
      for (var task in module.tasks) {
        if (startTime.isAfter(task.startDate) &&
            startTime.isBefore(task.endDate)) {
          isEventDate = true;
          break;
        }
      }
      if (isEventDate) {
        break;
      }
    }

    if (isEventDate) {
      return Container(
        color: Colors.red,
      );
    } else {
      return Container();
    }
  }

  // Méthode pour gérer la sélection d'un projet
  void _onProjectSelected(Project? project) {
    setState(() {
      if (_selectedProject == project) {
        _selectedProject = null;
      } else {
        _selectedProject = project;
      }
    });
  }

  void _showEventDetails(BuildContext context, DateTime selectedDate) {
    List<Widget> eventWidgets = [];

    if (_selectedProject != null) {
      for (var module in _selectedProject!.modules) {
        if ((module.moduleStartDate.isAtSameMomentAs(selectedDate) ||
                module.moduleStartDate.isBefore(selectedDate)) &&
            (module.moduleEndDate.isAtSameMomentAs(selectedDate) ||
                module.moduleEndDate.isAfter(selectedDate))) {
          eventWidgets.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Module: ${module.calendermoduleName}'),
                Text('Start Date: ${module.moduleStartDate}'),
                Text('End Date: ${module.moduleEndDate}'),
              ],
            ),
          );
        }
        for (var task in module.tasks) {
          if ((task.startDate.isAtSameMomentAs(selectedDate) ||
                  task.startDate.isBefore(selectedDate)) &&
              (task.endDate.isAtSameMomentAs(selectedDate) ||
                  task.endDate.isAfter(selectedDate))) {
            eventWidgets.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Task: ${task.taskName}'),
                  Text('Start Date: ${task.startDate}'),
                  Text('End Date: ${task.endDate}'),
                ],
              ),
            );
          }
        }
      }
    }

    if (eventWidgets.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No events on ${selectedDate.toString()}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AnimatedPadding(
          duration: Duration(milliseconds: 1000),
          padding: EdgeInsets.all(16.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.orange, width: 2.0),
            ),
            backgroundColor: Colors.grey.withOpacity(0.9),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Events on ${selectedDate.toString()}',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ...eventWidgets, // Ajouter les widgets d'événement
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Close',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Méthode pour construire l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Project Calendar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      // Fond noir pour toute l'application
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card for Selected Project Details
            _selectedProject != null
                ? Card(
                    color: Colors.grey.withOpacity(0.9),
                    // Ajoutez la bordure orange ici
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.orange, width: 4.0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Project Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Start Date: ${_selectedProject!.startDate}'),
                          Text('End Date: ${_selectedProject!.endDate}'),
                          Text(
                              'Total Duration: ${_selectedProject!.totalDuration}'),
                          SizedBox(height: 16),
                          Text(
                            'Modules:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _selectedProject!.modules.length,
                            itemBuilder: (context, index) {
                              final module = _selectedProject!.modules[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Module Name: ${module.calendermoduleName}'),
                                  SizedBox(height: 4),
                                  Text('Start Date: ${module.moduleStartDate}'),
                                  Text('End Date: ${module.moduleEndDate}'),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tasks:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: module.tasks.length,
                                    itemBuilder: (context, index) {
                                      final task = module.tasks[index];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: Text(task.taskName),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Duration: ${task.Duration} days'),
                                                Text(
                                                    'Start Date: ${task.startDate}'),
                                                Text(
                                                    'End Date: ${task.endDate}'),
                                              ],
                                            ),
                                            contentPadding: EdgeInsets.all(0),
                                          ),
                                          Divider(),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            // Calendar View
            Card(
              color: Colors.grey.withOpacity(0.9),
              // Ajoutez la bordure orange ici
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.orange, width: 4.0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.orange,
                      width: 4.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SfCalendar(
                    view: _currentView,
                    showNavigationArrow: true,
                    appointmentTextStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                    dataSource: ProjectDataSource(
                      _selectedProject != null ? [_selectedProject!] : [],
                    ),
                    appointmentBuilder: _getAppointmentWidget,
                    onTap: (CalendarTapDetails details) {
                      if (details.targetElement ==
                          CalendarElement.calendarCell) {
                        _showEventDetails(context, details.date!);
                      }
                    },
                  ),
                ),
              ),
            ),
            // List of Projects
            Card(
              color: Colors.grey.withOpacity(0.9),
              // Ajoutez la bordure orange ici
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.orange, width: 4.0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView.builder(
                  itemCount: _projects.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        'Module: ${_projects[index].modules.first.calendermoduleName}',
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        'Start: ${_projects[index].startDate}, End: ${_projects[index].endDate}',
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        _onProjectSelected(_projects[index]);
                      },
                      tileColor: Colors.grey
                          .withOpacity(0.5), // Définir la couleur de fond jaune
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.orange,
                            width: 2.0), // Définir la bordure
                        borderRadius: BorderRadius.circular(
                            8.0), // Définir les coins arrondis
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DataSource personnalisé pour le calendrier
class ProjectDataSource extends CalendarDataSource {
  ProjectDataSource(List<Project> source) {
    List<Appointment> appointments = [];
    for (var project in source) {
      for (var module in project.modules) {
        for (var task in module.tasks) {
          appointments.add(Appointment(
            startTime: task.startDate,
            endTime: task.endDate,
            isAllDay: true,
            color: Colors.red,
          ));
        }
      }
    }
    this.appointments = appointments;
  }
}