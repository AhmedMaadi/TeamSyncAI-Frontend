class Module {
  final String module_id;
  final String module_name;
  final String projectID;
  final List<String> teamM; // Added team field



  Module({
    required this.module_id,
    required this.module_name,
    required this.projectID,
    required this.teamM,

  });

  Map<String, dynamic> toJson() {
    return {
      '_id': module_id,
      'module_name': module_name,
      'projectID': projectID,
      'teamM': teamM,
    };
  }

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      module_id: json['_id'],
      module_name: json['module_name'],
      projectID: json['projectID'],
      teamM: List<String>.from(json['teamM']), // Parse team from JSON

    );
  }
}