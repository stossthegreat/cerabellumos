import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/coaching_message.dart';

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
    
    // For dev/testing: Always send x-user-id header
    // Backend will use this if no Firebase token is present
    final effectiveUserId = userId ?? 'test-user-123';
    
    return {
      'Content-Type': 'application/json',
      'x-user-id': effectiveUserId, // Dev mode auth
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ============================================================
  // PROJECTS (Neural Canvas)
  // ============================================================

  static Future<Map<String, dynamic>> sendMessage(
    String projectId,
    String message,
  ) async {
    print('📡 [API] sendMessage called');
    print('📡 [API] URL: $baseUrl/projects/$projectId/message');
    print('📡 [API] Message: ${message.substring(0, message.length > 50 ? 50 : message.length)}...');
    
    final headers = await _getHeaders();
    print('📡 [API] Headers: $headers');
    
    final response = await http.post(
      Uri.parse('$baseUrl/projects/$projectId/message'),
      headers: headers,
      body: jsonEncode({'content': message}), // Backend expects 'content' not 'message'
    );

    print('📡 [API] Response status: ${response.statusCode}');
    print('📡 [API] Response body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Backend returns { ok: true, aiMessage: { content: "..." } }
      return {
        'reply': data['aiMessage']?['content'] ?? 'No response',
      };
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
    print('📡 [API] createProject called');
    print('📡 [API] URL: $baseUrl/projects');
    print('📡 [API] Name: $name, Emoji: $emoji');
    
    final headers = await _getHeaders();
    print('📡 [API] Headers: $headers');
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/projects'),
        headers: headers,
        body: jsonEncode({'name': name, 'emoji': emoji}),
      );

      print('📡 [API] Response status: ${response.statusCode}');
      print('📡 [API] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('📡 [API] Project created: ${data['project']['id']}');
        return data['project'];
      } else {
        throw Exception('Failed to create project: Status ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('❌ [API] createProject exception: $e');
      print('❌ [API] Stack: $stackTrace');
      rethrow;
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

  // ========================
  // COACHING MESSAGES
  // ========================

  static Future<List<CoachingMessage>> getCoachingMessages() async {
    print('📊 Fetching coaching messages...');
    final headers = await _getHeaders();
    
    final response = await http.get(
      Uri.parse('$baseUrl/api/coaching/messages'),
      headers: headers,
    );

    print('📊 Coaching messages response: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      print('📊 Received ${data.length} coaching messages');
      return data.map((m) => CoachingMessage.fromJson(m)).toList();
    } else {
      print('❌ Failed to fetch coaching messages: ${response.body}');
      return [];
    }
  }

  static Future<void> dismissCoachingMessage(String messageId) async {
    print('🗑️ Dismissing coaching message: $messageId');
    final headers = await _getHeaders();
    
    await http.post(
      Uri.parse('$baseUrl/api/coaching/messages/$messageId/dismiss'),
      headers: headers,
    );
  }

  static Future<void> completeCoachingAction(String messageId, String actionType) async {
    print('✅ Completing coaching action: $actionType for message $messageId');
    final headers = await _getHeaders();
    
    await http.post(
      Uri.parse('$baseUrl/api/coaching/messages/$messageId/complete'),
      headers: headers,
      body: jsonEncode({'actionType': actionType}),
    );
  }

  static Future<void> generateCoachingMessages() async {
    print('🎯 Manually triggering coaching generation...');
    final headers = await _getHeaders();
    
    final response = await http.post(
      Uri.parse('$baseUrl/api/coaching/generate'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('✅ Coaching messages generated successfully');
    } else {
      print('❌ Failed to generate coaching messages: ${response.body}');
    }
  }
}

