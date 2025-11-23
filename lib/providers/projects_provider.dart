import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../services/api_service.dart';

class Project {
  final String id;
  final String name;
  final String emoji;
  final double power;
  final DateTime lastActive;
  bool pinned;
  final String momentum;

  Project({
    required this.id,
    required this.name,
    required this.emoji,
    required this.power,
    required this.lastActive,
    this.pinned = false,
    this.momentum = '+0%',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'power': power,
        'lastActive': lastActive.toIso8601String(),
        'pinned': pinned,
        'momentum': momentum,
      };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'],
        name: json['name'],
        emoji: json['emoji'],
        power: json['power'],
        lastActive: DateTime.parse(json['lastActive']),
        pinned: json['pinned'] ?? false,
        momentum: json['momentum'] ?? '+0%',
      );

  String get lastActiveText {
    final diff = DateTime.now().difference(lastActive);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}

class ProjectsProvider extends ChangeNotifier {
  List<Project> _projects = [];
  String? _activeProjectId;
  final _uuid = const Uuid();

  List<Project> get projects => _projects;
  List<Project> get pinnedProjects => _projects.where((p) => p.pinned).toList();
  String? get activeProjectId => _activeProjectId;
  Project? get activeProject =>
      _activeProjectId != null
          ? _projects.firstWhere((p) => p.id == _activeProjectId)
          : null;

  ProjectsProvider() {
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final projectsJson = prefs.getString('projects');
    if (projectsJson != null) {
      final List<dynamic> decoded = json.decode(projectsJson);
      _projects = decoded.map((e) => Project.fromJson(e)).toList();
    } else {
      // Initialize with default projects
      _projects = [
        Project(
          id: _uuid.v4(),
          name: 'Chemistry Revision',
          emoji: '⚗️',
          power: 8.9,
          lastActive: DateTime.now(),
          pinned: true,
          momentum: '+45%',
        ),
        Project(
          id: _uuid.v4(),
          name: 'Biology Notes',
          emoji: '🧬',
          power: 9.2,
          lastActive: DateTime.now().subtract(const Duration(hours: 2)),
          pinned: true,
          momentum: '+62%',
        ),
        Project(
          id: _uuid.v4(),
          name: 'Math Problems',
          emoji: '📐',
          power: 7.1,
          lastActive: DateTime.now().subtract(const Duration(days: 1)),
          pinned: false,
          momentum: '+28%',
        ),
      ];
      await _saveProjects();
    }
    notifyListeners();
  }

  Future<void> _saveProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final projectsJson = json.encode(_projects.map((p) => p.toJson()).toList());
    await prefs.setString('projects', projectsJson);
  }

  Future<void> addProject(Project project) async {
    _projects.insert(0, project);
    await _saveProjects();
    notifyListeners();
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere((p) => p.id == id);
    if (_activeProjectId == id) {
      _activeProjectId = null;
    }
    await _saveProjects();
    notifyListeners();
  }

  Future<void> togglePin(String id) async {
    final project = _projects.firstWhere((p) => p.id == id);
    project.pinned = !project.pinned;
    await _saveProjects();
    notifyListeners();
  }

  void setActiveProject(String? id) {
    _activeProjectId = id;
    if (id != null) {
      final project = _projects.firstWhere((p) => p.id == id);
      _projects.remove(project);
      _projects.insert(
        0,
        Project(
          id: project.id,
          name: project.name,
          emoji: project.emoji,
          power: project.power,
          lastActive: DateTime.now(),
          pinned: project.pinned,
          momentum: project.momentum,
        ),
      );
      _saveProjects();
    }
    notifyListeners();
  }

  Future<void> createProject({
    required String name,
    required String emoji,
    double power = 5.0,
    bool pinned = false,
  }) async {
    try {
      // Create project in backend API
      final response = await ApiService.createProject(name, emoji);
      
      // Backend returns the project with an ID
      final project = Project(
        id: response['id'],
        name: response['name'],
        emoji: response['emoji'],
        power: power,
        lastActive: DateTime.now(),
        pinned: pinned,
        momentum: '+0%',
      );
      
      await addProject(project);
    } catch (e) {
      print('❌ Error creating project: $e');
      rethrow;
    }
  }
}

