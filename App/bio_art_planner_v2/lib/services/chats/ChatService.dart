import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bio_art_planner_v2/models/chats/ChatRoom.dart';
import 'package:bio_art_planner_v2/models/chats/ChatMessage.dart';

class ChatService {
  static const String _baseApi = 'http://10.0.2.2:8000';

  Future<List<ChatRoom>> getAllChatRooms() async {
    try {
      final url = '$_baseApi/chatrooms';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final chatRooms = json.map((e) => ChatRoom.fromJson(e)).toList();
        print('Fetched chat rooms: $chatRooms');
        return chatRooms;
      } else {
        print('Failed to load chat rooms: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching chat rooms: $e');
    }
    return [];
  }

  Future<List<ChatRoom>> getUserChatRooms(int userId) async {
    try {
      final url = '$_baseApi/chatrooms/$userId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final chatRooms = json.map((e) => ChatRoom.fromJson(e)).toList();
        return chatRooms;
      } else {
        print('Failed to load user chat rooms: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user chat rooms: $e');
    }
    return [];
  }

  Future<bool> createUserChatRoom(int userId, int chatRoomId) async {
    try {
      final url = '$_baseApi/user-chat-room';
      final uri = Uri.parse(url);
      final body = jsonEncode({'userId': userId, 'chatRoomId': chatRoomId});
      final response = await http.post(uri, body: body, headers: {
        'Content-Type': 'application/json',
      });

      return response.statusCode == 201;
    } catch (e) {
      print('Error creating user chat room: $e');
    }
    return false;
  }

  Future<void> sendMessage(int chatRoomId, int userId, String message) async {
    final url = '$_baseApi/send-message';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'chat_room_id': chatRoomId,
        'user_id': userId,
        'message': message,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }

  Future<List<ChatMessage>> getMessages(int chatRoomId) async {
    try {
      final url = '$_baseApi/get-messages/$chatRoomId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final messages = json.map((e) => ChatMessage.fromJson(e)).toList();
        return messages;
      } else {
        print('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
    return [];
  }
}