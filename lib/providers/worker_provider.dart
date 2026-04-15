import 'package:flutter/material.dart';
import '../models/cv_model.dart';
import '../models/task_model.dart';
import '../models/workshop_model.dart';
import '../repositories/worker_repository.dart';

class WorkerProvider extends ChangeNotifier {
  final WorkerRepository _repo = WorkerRepository();

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

  Future<bool> addSkills(List<String> skills) async {
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

  // ── Workshops ─────────────────────────────────────────────
  List<WorkshopModel> _workshops = [];
  List<WorkshopModel> get workshops => _workshops;

  Future<void> fetchWorkshops() async {
    _setLoading(true);
    try {
      final res = await _repo.getWorkshops();
      if (res['success'] == true && res['data'] != null) {
        _workshops = (res['data'] as List)
            .map((json) => WorkshopModel.fromJson(json))
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

  Future<void> fetchTasks() async {
    _setLoading(true);
    try {
      final res = await _repo.getTasks();
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
      await fetchTasks(); // Refresh
      _errorMessage = null;
      _setLoading(false);
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
