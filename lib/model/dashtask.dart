class Task {
  final String taskId;
  final String moduleId;
  final String projectID;
  final String taskDescription;
  final List<String> team;
  final bool completed;
  final DateTime date; // Added date field

  Task({
    required this.taskId,
    required this.moduleId,
    required this.projectID,
    required this.taskDescription,
    required this.team,
    required this.completed,
    required this.date, // Include date in the constructor
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': taskId,
      'module_id': moduleId,
      'projectID': projectID,
      'task_description': taskDescription,
      'team': team,
      'completed': completed,
      'date': date.toIso8601String(), // Convert DateTime to ISO 8601 string
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['_id'],
      moduleId: json['module_id'],
      projectID: json['projectID'],
      taskDescription: json['task_description'],
      completed: json['completed'],
      team: List<String>.from(json['team']),
      date: DateTime.parse(json['date']), // Parse ISO 8601 string to DateTime
    );
  }
}
