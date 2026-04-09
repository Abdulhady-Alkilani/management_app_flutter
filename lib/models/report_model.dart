class ReportModel {
  final int id;
  final int? projectId;
  final int? workshopId;
  final int? serviceId;
  final String reportType;
  final String reportDetails;

  ReportModel({
    required this.id,
    this.projectId,
    this.workshopId,
    this.serviceId,
    required this.reportType,
    required this.reportDetails,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      projectId: json['project_id'],
      workshopId: json['workshop_id'],
      serviceId: json['service_id'],
      reportType: json['report_type'] ?? '',
      reportDetails: json['report_details'] ?? '',
    );
  }
}
