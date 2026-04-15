class ApiConstants {
  // Use optimal local IP for emulator or real device debugging.
  // For production, this should be the live server domain.
  static const String baseUrl = "http://10.140.183.183:8000/api/v1";

  // Auth
  static const String login = "$baseUrl/login";
  static const String logout = "$baseUrl/logout";
  static const String user = "$baseUrl/user";

  // Engineer
  static const String engCv = "$baseUrl/engineer/cv";
  static const String engSkills = "$baseUrl/engineer/skills";
  static const String engProjects = "$baseUrl/engineer/projects";
  static const String engTasks = "$baseUrl/engineer/tasks";
  static const String engReports = "$baseUrl/engineer/reports";

  // Worker
  static const String workerCv = "$baseUrl/worker/cv";
  static const String workerSkills = "$baseUrl/worker/skills";
  static const String workerWorkshops = "$baseUrl/worker/workshops";
  static const String workerTasks = "$baseUrl/worker/tasks";
}
