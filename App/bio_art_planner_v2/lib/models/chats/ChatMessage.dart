import 'package:flutter/foundation.dart';

class ChatMessage {
  final int id;
  final int chat_room_id;
  final int user_id;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.chat_room_id,
    required this.user_id,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int? ?? 0,
      chat_room_id: json['chat_room_id'] as int? ?? 0,
      user_id: json['user_id'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_room_id': chat_room_id,
      'user_id': user_id,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}