class CvModel {
  final int id;
  final String profileDetails;
  final String experience;
  final String education;
  final String? cvFileUrl;
  final int? aiScore;
  final List<dynamic> skills;

  CvModel({
    required this.id,
    required this.profileDetails,
    required this.experience,
    required this.education,
    this.cvFileUrl,
    this.aiScore,
    required this.skills,
  });

  factory CvModel.fromJson(Map<String, dynamic> json) {
    return CvModel(
      id: json['id'],
      profileDetails: json['profile_details'] ?? '',
      experience: json['experience'] ?? '',
      education: json['education'] ?? '',
      cvFileUrl: json['cv_file_url'],
      aiScore: json['ai_score'],
      skills: json['skills'] ?? [],
    );
  }
}
