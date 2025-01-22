import 'dart:convert';
import 'package:bio_art_planner_v2/models/classes/Message.dart';
import 'package:bio_art_planner_v2/models/classes/many_many/User_Message.dart';
import 'package:bio_art_planner_v2/models/services/MessageServices.dart';
import 'package:bio_art_planner_v2/models/services/UserServices.dart';

import '../../classes/User.dart';
import 'package:http/http.dart' as http;
class UserMessageServices{
  static const String _baseApi = 'http://10.0.2.2:8000';
  // om messages op te halen
  
  Future getUserMessagesByUserId(int userId) async {
    try {
      final url = '$_baseApi/usermessage/$userId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final json = jsonDecode(response.body) as List;
      final userMessages = json.map((e) {
        return UserMessage(
          usersMessagesId: e['usersMessagesId'],
          userId: e['userId'] ?? '',
          messageId: e['messageId'] ?? '',
        );
      }).toList();
      UserServices userServices = UserServices();
      MessageServices messageServices = MessageServices();
      late User user;
      List<Message> messages = [];
      user = await userServices.getUserById(userId);
      for(var i = 0; i < userMessages.length; i++){
        messages.add(await messageServices.getMessageById(userMessages[i].messageId));
      }
      if (response.statusCode == 200) {
        return print({
          "user": user.toJson(),
          "messages": messages.first.toJson()
        });
      }
    } catch (e) {
      print(e);
    }
  }

  //Om users op te halen
  Future getMessageUsersByMessageId(int messageId) async {
    try {
      final url = '$_baseApi/messageuser/$messageId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final json = jsonDecode(response.body) as List;
      final userMessages = json.map((e) {
        return UserMessage(
          usersMessagesId: e['usersMessagesId'],
          userId: e['userId'] ?? '',
          messageId: e['messageId'] ?? '',
        );
      }).toList();
      UserServices userServices = UserServices();
      MessageServices messageServices = MessageServices();
      late Message message;
      List<User> users  = [];
      message = await messageServices.getMessageById(messageId);
      for(var i = 0; i < userMessages.length; i++){
        users.add(await userServices.getUserById(userMessages[i].userId));
      }
      if (response.statusCode == 200) {
        return print({
          "message": message.toJson(),
          "users": users.first.toJson()
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future makeUserMessage(UserMessage userMessage) async {
    try {
      const url = '$_baseApi/usermessage/';
      final uri = Uri.parse(url);
      final body = {
        "userId": userMessage.userId,
        "messageId": userMessage.messageId
      };
      final response = await http.post(uri, body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 201) {
        return response;
      } else {
        return "something went wrong";
      }
    } catch (e) {
      print(e);
    }
  }

  Future deleteUserMessage(int userMessageId) async {
    try {
      final url = '$_baseApi/usermessage/$userMessageId';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future editUserMessage(UserMessage userMessage, int userMessageId) async {
    try {
      final url = '$_baseApi/usermessage/$userMessageId';
      final uri = Uri.parse(url);
      final body = {
        "userId": userMessage.userId,
        "messageId": userMessage.messageId
      };
      final response = await http.patch(uri, body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        return print(true);
      }
    } catch (e) {
      print(e);
    }
  }
}