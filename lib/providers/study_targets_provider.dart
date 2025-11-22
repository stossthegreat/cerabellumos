import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class StudyTarget {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  bool isCompleted;
  final String emoji;

  StudyTarget({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    this.emoji = '🎯',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'isCompleted': isCompleted,
        'emoji': emoji,
      };

  factory StudyTarget.fromJson(Map<String, dynamic> json) => StudyTarget(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        isCompleted: json['isCompleted'] ?? false,
        emoji: json['emoji'] ?? '🎯',
      );

  int get daysRemaining => endDate.difference(DateTime.now()).inDays;
  int get totalDays => endDate.difference(startDate).inDays;
  double get progress {
    final elapsed = DateTime.now().difference(startDate).inDays;
    final total = totalDays;
    return total > 0 ? (elapsed / total).clamp(0.0, 1.0) : 0.0;
  }
}

class StudyTargetsProvider extends ChangeNotifier {
  List<StudyTarget> _targets = [];
  final _uuid = const Uuid();

  List<StudyTarget> get targets => _targets;
  List<StudyTarget> get activeTargets =>
      _targets.where((t) => !t.isCompleted).toList();

  StudyTargetsProvider() {
    _loadTargets();
  }

  Future<void> _loadTargets() async {
    final prefs = await SharedPreferences.getInstance();
    final targetsJson = prefs.getString('study_targets');
    if (targetsJson != null) {
      final List<dynamic> decoded = json.decode(targetsJson);
      _targets = decoded.map((e) => StudyTarget.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveTargets() async {
    final prefs = await SharedPreferences.getInstance();
    final targetsJson = json.encode(_targets.map((t) => t.toJson()).toList());
    await prefs.setString('study_targets', targetsJson);
  }

  Future<void> addTarget(StudyTarget target) async {
    _targets.add(target);
    await _saveTargets();
    notifyListeners();
  }

  Future<void> toggleComplete(String id) async {
    final target = _targets.firstWhere((t) => t.id == id);
    target.isCompleted = !target.isCompleted;
    await _saveTargets();
    notifyListeners();
  }

  Future<void> deleteTarget(String id) async {
    _targets.removeWhere((t) => t.id == id);
    await _saveTargets();
    notifyListeners();
  }

  Future<void> createTarget({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    String emoji = '🎯',
  }) async {
    final target = StudyTarget(
      id: _uuid.v4(),
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      emoji: emoji,
    );
    await addTarget(target);
  }
}

