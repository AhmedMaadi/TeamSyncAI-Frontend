class Project {
  String name;
  DateTime startDate;
  DateTime endDate;
  String description;
  List<String> keywords;
  String teamLeader;
  List<String> members;

  Project({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.keywords,
    required this.teamLeader,
    required this.members,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'description': description,
      'keywords': keywords,
      'teamLeader': teamLeader,
      'members': members,
    };
  }
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      description: json['description'],
      keywords: List<String>.from(json['keywords']),
      teamLeader: json['teamLeader'],
      members: List<String>.from(json['members']),
    );
  }
}