// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Management System';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginSubtitle => 'Enter your details to continue';

  @override
  String get usernameLabel => 'Username';

  @override
  String get usernameHint => 'Please enter username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Please enter password';

  @override
  String get loginButton => 'Login';

  @override
  String get loginFailed => 'Login failed. Check your credentials.';

  @override
  String get engineerDashboard => 'Engineer Dashboard';

  @override
  String get workerDashboard => 'Worker Dashboard';

  @override
  String get projects => 'Projects';

  @override
  String get tasks => 'Tasks';

  @override
  String get reports => 'Reports';

  @override
  String get myCv => 'My CV';

  @override
  String get workshops => 'Workshops';

  @override
  String get logout => 'Logout';

  @override
  String get addSkill => 'Add Skill';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusCanceled => 'Canceled';

  @override
  String get updateTask => 'Update Task';

  @override
  String get updateTaskProgress => 'Update Task Progress';

  @override
  String get taskProgress => 'Progress';

  @override
  String get taskStatus => 'Status';

  @override
  String get noTasks => 'No tasks currently.';

  @override
  String get noProjects => 'No projects currently.';

  @override
  String get noWorkshops => 'No workshops currently.';

  @override
  String get noReports => 'No reports currently.';

  @override
  String get createReport => 'Create Report';

  @override
  String get reportTitle => 'Report Title';

  @override
  String get reportContent => 'Report Content';

  @override
  String get addReportSuccess => 'Report added successfully';

  @override
  String get addReportFailed => 'Failed to add report';

  @override
  String get updateTaskSuccess => 'Task updated successfully';

  @override
  String get updateTaskFailed => 'Update failed';

  @override
  String get errorProgressCompleted =>
      'Status must be \'Completed\' if progress is 100%';

  @override
  String get errorStatusCompleted =>
      'Cannot select \'Completed\' unless progress is 100%';

  @override
  String get addSkillsTitle => 'Add Skills';

  @override
  String get availableSkills => 'Available Skills:';

  @override
  String get addNewSkills => 'Or add new skills:';

  @override
  String get skillsHint => 'Enter skills separated by commas';

  @override
  String get addSkillsSuccess => 'Skills added successfully';

  @override
  String get addSkillsFailed => 'Failed to add skills';

  @override
  String get all => 'All';

  @override
  String get cvTitle => 'Resume / CV';

  @override
  String get yearsOfExperience => 'Years of Experience';

  @override
  String get skills => 'Skills:';

  @override
  String get noSkills => 'No skills added';

  @override
  String get generalInfo => 'General Info';

  @override
  String get workshopInfo => 'Workshop Info';

  @override
  String get projectInfo => 'Project Info';

  @override
  String get description => 'Description';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get taskDetails => 'Task Details';

  @override
  String get loading => 'Loading...';
}
