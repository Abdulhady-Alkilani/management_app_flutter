class ProjectModel {
  final int id;
  final String name;
  final String status;

  ProjectModel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'] ?? '',
      status: json['status'] ?? 'مفتوح',
    );
  }
}
