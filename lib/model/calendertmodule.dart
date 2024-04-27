import 'package:teamsyncai/model/calendertask.dart';
import 'package:teamsyncai/model/calendertmodule.dart';



class CalenderModule {
  final String calendermoduleName;
  final DateTime moduleStartDate;
  final int totalDuration;
  final DateTime moduleEndDate;
  final List<Task> tasks;

  CalenderModule({
    required this.calendermoduleName,
    required this.moduleStartDate,
    required this.totalDuration,
    required this.moduleEndDate,
    required this.tasks,
  });

  factory CalenderModule.fromJson(Map<String, dynamic> json) {
    List<Task> tasks = (json['tasks'] as List)
        .map((taskData) => Task.fromJson(taskData))
        .toList();

    return CalenderModule(
      calendermoduleName: json['module_name'],
      totalDuration: json['total_duration'],
      moduleStartDate: DateTime.parse(json['module_start_date']),
      moduleEndDate: DateTime.parse(json['module_end_date']),
      tasks: tasks,
    );
  }
}