import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // 🚂 RAILWAY PRODUCTION BACKEND
  static const String baseUrl = 'https://cerabellumos-production.up.railway.app';
  
  // For local development, use:
  // static const String baseUrl = 'http://10.0.2.2:8080'; // Android emulator
  // static const String baseUrl = 'http://localhost:8080'; // iOS simulator
  
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  static Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    final userId = await _getUserId();
    
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (userId != null) 'x-user-id': userId,
    };
  }

  // ============================================================
  // PROJECTS (Neural Canvas)
  // ============================================================

  static Future<Map<String, dynamic>> sendMessage(
    String projectId,
    String message,
  ) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/projects/$projectId/message'),
      headers: headers,
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send message: ${response.body}');
    }
  }

  static Future<List<dynamic>> getMessages(String projectId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/projects/$projectId/messages'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['messages'] ?? [];
    } else {
      throw Exception('Failed to load messages');
    }
  }

  static Future<Map<String, dynamic>> createProject(
    String name,
    String emoji,
  ) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/projects'),
      headers: headers,
      body: jsonEncode({'name': name, 'emoji': emoji}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['project'];
    } else {
      throw Exception('Failed to create project');
    }
  }

  // ============================================================
  // STATS & IDENTITY
  // ============================================================

  static Future<Map<String, dynamic>> getStats() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/stats/summary'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load stats');
    }
  }

  static Future<Map<String, dynamic>> getIdentity() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/user/identity'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load identity');
    }
  }

  // ============================================================
  // INTEL
  // ============================================================

  static Future<Map<String, dynamic>> getLatestIntel() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/intel/latest'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load intel');
    }
  }

  // ============================================================
  // SCANNER
  // ============================================================

  static Future<Map<String, dynamic>> solveProblem(
    String imageBase64,
    String? subject,
  ) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/scan/solve'),
      headers: headers,
      body: jsonEncode({
        'ocrText': imageBase64, // Backend will do OCR
        'subject': subject,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to solve problem');
    }
  }
}

