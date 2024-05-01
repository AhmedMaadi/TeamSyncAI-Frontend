import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:teamsyncai/screens/calenderscreen/calendar_screen.dart';
import 'package:teamsyncai/screens/chatscreen/chatroom.dart';
import 'package:teamsyncai/screens/dashboardscreen/plus.dart';
import 'package:teamsyncai/screens/profile.dart';
import 'package:teamsyncai/screens/task.dart/modulesList.dart';
import 'package:teamsyncai/screens/task.dart/taskPage.dart';
import 'package:teamsyncai/screens/task.dart/taskmain.dart';
import '../model/dashtask.dart';
import '../model/module.dart';
import '../model/project.dart';
import '../services/api_service.dart';
import "../services/task_module_service.dart";
import 'package:http/http.dart' as http;

class home extends StatefulWidget {
  final String email;

  const home({required this.email});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<home> with Task_Module_service {
  late ScrollController _scrollController;
  int _selectedIndex = 0;
  List<Project> projects = []; // List to store fetched projects
  late Future<List<Module>> _modulesFuture;

  @override
  void initState() {
    super.initState();
    fetchProjectsByEmail(); // Call function to fetch projects
    _modulesFuture = fetchModulesByEmail(widget.email);

    _scrollController = ScrollController(); // Initialize ScrollController
    _scrollController.addListener(_onScroll); // Add listener
  }

  void _onScroll() {
    if (_scrollController.position.pixels == 0) {
      setState(() {
        _modulesFuture = fetchModulesByEmail(widget.email);
        fetchProjectsByEmail();
      });
    }
  }
  Future<void> _refreshData() async {
    setState(() {
      fetchProjectsByEmail();
      _modulesFuture = fetchModulesByEmail(widget.email);
    });
  }



  void fetchProjectsByEmail() async {
    try {
      List<Project> fetchedProjects = await ApiService.fetchProjects(
          email: widget.email);
      setState(() {
        projects = fetchedProjects;
      });
    } catch (e) {
      print('Error fetching projects: $e');
    }
  }
  Future<Map<String, dynamic>> fetchProjects() async {
    final response =
    await http.get(Uri.parse('http://192.168.1.12:3000/projectss'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load projects');
    }
  }


  Future<String> fetchProjectName(String projectId) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.15:3000/project/$projectId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['projectName'];
      } else {
        throw Exception('Failed to fetch project name');
      }
    } catch (error) {
      print('Error fetching project name: $error');
      throw Exception('Failed to fetch project name');
    }
  }
  double calculateCompletionPercentage(List<Task> tasks) {
    if (tasks.isEmpty) return 0;
    int completedCount = 0;
    for (var task in tasks) {
      if (task.completed) completedCount++;
    }
    return (completedCount / tasks.length) * 100;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => taskmain(email: widget.email)),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProjectFirst(email: widget.email)),
      );
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CalendarScreen(email: widget.email)),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatroomListPage(email: widget.email)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: AssetImage('assets/images/zz.png'),
            ),
            SizedBox(width: 8), // Add some spacing between avatar and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning !',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.email.split('@').first,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              'TeamSyncAi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 15),
                Text(
                  'Projects',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < projects.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: SizedBox(
                        width: 250,
                        height: 200,
                        child: Card(
                          elevation: 3,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 100,
                                child: Container(
                                  color: Colors.orangeAccent,
                                  child: ListTile(
                                    title: Text(
                                      projects[i].name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      projects[i].description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 100,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(width: 15),
                Text(
                  'Modules',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Module>>(
                future: _modulesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Module> modules = snapshot.data!;
                    return ListView.builder(
                      itemCount: modules.length,
                      itemBuilder: (context, index) {
                        var module = modules[index];
                        return FutureBuilder<String>(
                          future: fetchProjectName(module.projectID),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              String projectName = snapshot.data!;
                              return FutureBuilder<double>(
                                future: fetchCompletionPercentage(
                                    module.module_id),
                                builder: (context, completionSnapshot) {
                                  double completionPercentage =
                                      completionSnapshot.data ?? 0.0;
                                  return ListTileModule(
                                    projectTitle: projectName,
                                    moduleTitle: module.module_name,
                                    teamMembers: module.teamM,
                                    profileImagePaths: const [
                                      'assets/images/zz.png'
                                    ],
                                    percentage: completionPercentage,
                                    imagePath: 'assets/images/orange.jpg',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TasksPage(
                                            moduleId: module.module_id,
                                            moduleName: module.module_name,
                                            teamMembers: module.teamM,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Profile(email: widget.email)),
          );
        },
        child: const Icon(Icons.person_remove),
      ),
    );
  }
}


class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.orange,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.orange, // Set background color to orange
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
          backgroundColor: Colors.orange, // Set background color to orange
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Tasks',
          backgroundColor: Colors.orange, // Set background color to orange
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
          backgroundColor: Colors.orange, // Set background color to orange
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: 'More',
          backgroundColor: Colors.orange, // Set background color to orange
        ),
      ],
    );
  }
}