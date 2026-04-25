import 'package:flutter/material.dart';
import '../models/cv_model.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';
import '../models/report_model.dart';
import '../repositories/engineer_repository.dart';

class EngineerProvider extends ChangeNotifier {
  final EngineerRepository _repo = EngineerRepository();

  // ── Loading & Error State ─────────────────────────────────
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ── CV ────────────────────────────────────────────────────
  CvModel? _cv;
  CvModel? get cv => _cv;

  Future<void> fetchCv() async {
    _setLoading(true);
    try {
      final res = await _repo.getCv();
      if (res['success'] == true && res['data'] != null) {
        _cv = CvModel.fromJson(res['data']);
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  Future<bool> updateCv(Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      final res = await _repo.updateCv(data);
      if (res['success'] == true && res['data'] != null) {
        _cv = CvModel.fromJson(res['data']);
      }
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> addSkills(List<dynamic> skills) async {
    _setLoading(true);
    try {
      await _repo.addSkills(skills);
      await fetchCv(); // Refresh CV after adding skills
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // ── Available Skills ──────────────────────────────────────
  List<Map<String, dynamic>> _availableSkills = [];
  List<Map<String, dynamic>> get availableSkills => _availableSkills;

  Future<void> fetchAvailableSkills() async {
    try {
      final res = await _repo.getAvailableSkills();
      if (res['success'] == true && res['data'] != null) {
        _availableSkills = List<Map<String, dynamic>>.from(res['data']);
        notifyListeners();
      }
    } catch (e) {
      // ignore
    }
  }

  // ── Projects ──────────────────────────────────────────────
  List<ProjectModel> _projects = [];
  List<ProjectModel> get projects => _projects;

  Future<void> fetchProjects() async {
    _setLoading(true);
    try {
      final res = await _repo.getProjects();
      if (res['success'] == true && res['data'] != null) {
        _projects = (res['data'] as List)
            .map((json) => ProjectModel.fromJson(json))
            .toList();
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  // ── Tasks ─────────────────────────────────────────────────
  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  Future<void> fetchTasks({int? projectId}) async {
    _setLoading(true);
    try {
      final res = await _repo.getTasks(projectId: projectId);
      if (res['success'] == true && res['data'] != null) {
        _tasks = (res['data'] as List)
            .map((json) => TaskModel.fromJson(json))
            .toList();
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  Future<bool> updateTask(int taskId, Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      await _repo.updateTask(taskId, data);
      // Update the local task
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        await fetchTasks(); // Refresh
      }
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // ── Reports ───────────────────────────────────────────────
  List<ReportModel> _reports = [];
  List<ReportModel> get reports => _reports;

  Future<void> fetchReports() async {
    _setLoading(true);
    try {
      final res = await _repo.getReports();
      if (res['success'] == true && res['data'] != null) {
        _reports = (res['data'] as List)
            .map((json) => ReportModel.fromJson(json))
            .toList();
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  Future<bool> createReport(Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      await _repo.createReport(data);
      await fetchReports(); // Refresh
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateReport(int reportId, Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      await _repo.updateReport(reportId, data);
      await fetchReports(); // Refresh
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteReport(int reportId) async {
    _setLoading(true);
    try {
      await _repo.deleteReport(reportId);
      _reports.removeWhere((r) => r.id == reportId);
      _errorMessage = null;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<TaskModel?> getTaskDetails(int taskId) async {
    _setLoading(true);
    try {
      final res = await _repo.getTaskDetails(taskId);
      _setLoading(false);
      if (res['success'] == true && res['data'] != null) {
        return TaskModel.fromJson(res['data']);
      }
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return null;
    }
  }

  Future<ReportModel?> getReportDetails(int reportId) async {
    _setLoading(true);
    try {
      final res = await _repo.getReportDetails(reportId);
      _setLoading(false);
      if (res['success'] == true && res['data'] != null) {
        return ReportModel.fromJson(res['data']);
      }
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return null;
    }
  }

  // ── Helper ────────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
