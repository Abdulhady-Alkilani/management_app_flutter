class UserModel {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;
  final String? gender;
  final String? name; // Can be used when merging first and last name
  final List<String> roles;

  UserModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.gender,
    this.name,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      email: json['email'],
      gender: json['gender'],
      name: json['name'],
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
    );
  }
}
