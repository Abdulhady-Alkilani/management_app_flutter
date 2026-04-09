class WorkshopModel {
  final int id;
  final String name;
  final Map<String, dynamic>? project;

  WorkshopModel({
    required this.id,
    required this.name,
    this.project,
  });

  factory WorkshopModel.fromJson(Map<String, dynamic> json) {
    return WorkshopModel(
      id: json['id'],
      name: json['name'] ?? '',
      project: json['project'] != null ? Map<String, dynamic>.from(json['project']) : null,
    );
  }
}
