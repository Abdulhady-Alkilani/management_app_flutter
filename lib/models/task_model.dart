class TaskModel {
  final int id;
  final String description;
  final int progress;
  final String status;
  final String? startDate;
  final Map<String, dynamic>? project;
  final Map<String, dynamic>? workshop;

  TaskModel({
    required this.id,
    required this.description,
    required this.progress,
    required this.status,
    this.startDate,
    this.project,
    this.workshop,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      description: json['description'] ?? '',
      progress: json['progress'] ?? 0,
      status: json['status'] ?? 'قيد التنفيذ',
      startDate: json['start_date'],
      project: json['project'] != null ? Map<String, dynamic>.from(json['project']) : null,
      workshop: json['workshop'] != null ? Map<String, dynamic>.from(json['workshop']) : null,
    );
  }
}
