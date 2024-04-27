import 'package:flutter/material.dart';

import 'package:teamsyncai/model/module.dart';
import 'package:teamsyncai/screens/dashboardscreen/project4.dart';
import 'package:teamsyncai/screens/dashboardscreen/project5.dart';
import 'package:teamsyncai/services/api_service.dart';


class ProjectThird extends StatefulWidget {
  final String projectId;
  final String projectName;
  final String teamLeader;
  final List<String> members;
  final List<String> keywords;
  final DateTime startDate;
  final DateTime endDate;

  const ProjectThird({
    Key? key,
    required this.projectId,
    required this.projectName,
    required this.teamLeader,
    required this.members,
    required this.keywords,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  _ProjectThirdState createState() => _ProjectThirdState();
}

class _ProjectThirdState extends State<ProjectThird> {
  late List<Module> modules = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchModules();
  }

  Future<void> fetchModules() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Module> fetchedModules =
      await ApiService.fetchModules(widget.projectId);

      setState(() {
        modules = fetchedModules;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshModules() async {
    await fetchModules();
  }

  Future<void> _addDefaultModule() async {
    setState(() {
      isLoading = true;
    });
    try {
      Module newModule = await ApiService.createDefaultModule(widget.projectId);
      setState(() {
        modules.add(newModule);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
        backgroundColor: const Color(0xFFE89F16),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Name : ${widget.projectName}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Leader : ${widget.teamLeader}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Start time",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${widget.startDate.day}-${widget.startDate.month}-${widget.startDate.year}",
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "End time",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${widget.endDate.day}-${widget.endDate.month}-${widget.endDate.year}",
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshModules,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : modules.isEmpty
                    ? const Center(child: Text('No modules found'))
                    : ListView.builder(
                  itemCount: modules.length + 1,
                  itemBuilder: (context, index) {
                    if (index == modules.length) {
                      return IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _addDefaultModule,
                      );
                    }
                    final module = modules[index];
                    return Dismissible(
                      key: Key(module.module_id),
                      onDismissed: (direction) {
                        setState(() {
                          modules.remove(module);
                        });
                        ApiService.deleteModule(module.module_id)
                            .then((_) {})
                            .catchError((error) {
                          setState(() {
                            modules.add(module);
                          });
                        });
                      },
                      background: Container(
                        color: const Color(0xFFE89F16),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            module.module_name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProjectFifth(
                                  moduleId: module.module_id,
                                  moduleName: module.module_name,
                                  projectId: widget.projectId,
                                  teamM: module.teamM
                                ),
                              ),
                            ).then((value) {
                              if (value != null && value is List<Module>) {
                                setState(() {
                                  modules = value;
                                });
                              }
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProjectFourth()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE89F16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text("Confirm", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}