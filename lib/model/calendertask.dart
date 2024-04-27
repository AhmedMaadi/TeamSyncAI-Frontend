class Task {
  final String taskName;
  final String taskDescription;
  final int Duration;
  final DateTime startDate;
  final DateTime endDate;

  Task({
    required this.taskName,
    required this.taskDescription,
    required this.Duration,
    required this.startDate,
    required this.endDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskName: json['task_name'],
      taskDescription: json['task_description'],
      Duration: json['duration'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }
}