// lib/models/coaching_message.dart
// 🎯 Smart Coaching Message Model

class CoachingAction {
  final String type; // "flashcards", "quiz", "deep_dive", etc.
  final String label;
  final Map<String, dynamic> payload;

  CoachingAction({
    required this.type,
    required this.label,
    required this.payload,
  });

  factory CoachingAction.fromJson(Map<String, dynamic> json) {
    return CoachingAction(
      type: json['type'] as String,
      label: json['label'] as String,
      payload: json['payload'] as Map<String, dynamic>,
    );
  }
}

class WeakArea {
  final String topic;
  final int mastery;

  WeakArea({
    required this.topic,
    required this.mastery,
  });

  factory WeakArea.fromJson(Map<String, dynamic> json) {
    return WeakArea(
      topic: json['topic'] as String,
      mastery: json['mastery'] as int,
    );
  }
}

class CoachingPlan {
  final String description;
  final int totalTime; // minutes
  final int? predictedGain; // percentage
  final List<String>? breakdown;
  final String? reasoning;
  final String? urgency;

  CoachingPlan({
    required this.description,
    required this.totalTime,
    this.predictedGain,
    this.breakdown,
    this.reasoning,
    this.urgency,
  });

  factory CoachingPlan.fromJson(Map<String, dynamic> json) {
    return CoachingPlan(
      description: json['description'] as String,
      totalTime: json['totalTime'] as int,
      predictedGain: json['predictedGain'] as int?,
      breakdown: (json['breakdown'] as List<dynamic>?)?.map((e) => e as String).toList(),
      reasoning: json['reasoning'] as String?,
      urgency: json['urgency'] as String?,
    );
  }
}

class CoachingMessage {
  final String id;
  final String userId;
  final String type; // "exam_prep", "drift_recovery", "momentum", "consistency"
  final String priority; // "high", "medium", "low"
  final String title;
  final List<WeakArea>? weakAreas;
  final Map<String, dynamic>? context;
  final CoachingPlan plan;
  final List<CoachingAction> actions;
  final String status; // "active", "dismissed", "completed"
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime? readAt;
  final String? audioBase64; // Voice audio for this message

  CoachingMessage({
    required this.id,
    required this.userId,
    required this.type,
    required this.priority,
    required this.title,
    this.weakAreas,
    this.context,
    required this.plan,
    required this.actions,
    required this.status,
    required this.expiresAt,
    required this.createdAt,
    this.readAt,
    this.audioBase64,
  });

  factory CoachingMessage.fromJson(Map<String, dynamic> json) {
    // The 'content' field contains the full message data
    final content = json['content'] as Map<String, dynamic>;

    return CoachingMessage(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      priority: json['priority'] as String,
      title: json['title'] as String,
      weakAreas: (content['weakAreas'] as List<dynamic>?)
          ?.map((e) => WeakArea.fromJson(e as Map<String, dynamic>))
          .toList(),
      context: content['context'] as Map<String, dynamic>?,
      plan: CoachingPlan.fromJson(content['plan'] as Map<String, dynamic>),
      actions: (content['actions'] as List<dynamic>)
          .map((e) => CoachingAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt'] as String) : null,
      audioBase64: content['audioBase64'] as String?, // Extract audio from content
    );
  }
}

