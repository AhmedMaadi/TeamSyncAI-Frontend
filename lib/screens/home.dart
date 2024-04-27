import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:teamsyncai/screens/calenderscreen/calendar_screen.dart';
import 'package:teamsyncai/screens/chatscreen/chatroom.dart';
import 'package:teamsyncai/screens/dashboardscreen/plus.dart';
import 'package:teamsyncai/screens/profile.dart';
import 'package:teamsyncai/screens/task.dart/modulesList.dart';
import 'package:teamsyncai/screens/task.dart/taskPage.dart';
import 'package:teamsyncai/screens/task.dart/taskmain.dart';
import '../model/module.dart';
import '../model/project.dart';
import '../services/api_service.dart';
import 'package:http/http.dart' as http;

class home extends StatefulWidget {
  final String email;

  const home({required this.email});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<home> {
  int _selectedIndex = 0;
  List<Project> projects = []; // List to store fetched projects
  late Future<List<Module>> _modulesFuture;

  @override
  void initState() {
    super.initState();
    fetchProjectsByEmail(); // Call function to fetch projects
    _modulesFuture = fetchModulesByEmail(widget.email);
  }


  // Function to fetch projects by email
  void fetchProjectsByEmail() async {
    try {
      List<Project> fetchedProjects = await ApiService.fetchProjects(
          email: widget.email); // Call fetchProjects function
      setState(() {
        projects = fetchedProjects; // Update state with fetched projects
      });
    } catch (e) {
      print('Error fetching projects: $e');
    }
  }
  Future<Map<String, dynamic>> fetchProjects() async {
    final response =
    await http.get(Uri.parse('http://192.168.128.154:3000/projectss'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load projects');
    }
  }
  Future<List<Module>> fetchModulesByEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.128.154:3000/getMByEmail'),
        body: jsonEncode({'email': email}), // Pass email in the request body
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Module> modules = data.map<Module>((moduledata) {
          return Module.fromJson(moduledata);
        }).toList();

        return modules;
      } else {
        throw Exception('Failed to load modules');
      }
    } catch (e) {
      throw Exception('Error fetching modules: $e');
    }
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
            Spacer(), // Add a spacer to push TeamSyncAi to the right
            Text(
              'TeamSyncAi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8), // Add some spacing between text and right edge
          ],
        ),

      ),
      // Your body and other widgets go here
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 15),// Flexible space to push "Projects" slightly to the right
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
                      height: 200, // Adjust width as needed
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
                                    // Navigate to project details or do something else
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
              SizedBox(width: 15),// Flexible space to push "Projects" slightly to the right
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
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Module> modules = snapshot.data!;
                  return ListView.builder(
                    itemCount: modules.length,
                    itemBuilder: (context, index) {
                      var module = modules[index];
                      return ListTileModule(
                        projectTitle: module.projectID,
                        moduleTitle: module.module_name,
                        teamMembers: module.teamM,
                        profileImagePaths: const ['assets/images/zz.png'],
                        percentage: 50,
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
            ),
          ),
        ],
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
      backgroundColor: Colors.orange, // Set background color to orange
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
