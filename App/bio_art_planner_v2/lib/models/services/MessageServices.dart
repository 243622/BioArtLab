import 'dart:convert';
import '/models/classes/Message.dart';
import 'package:http/http.dart' as http;

class MessageServices {
  Future<List<Message>> getAll([limit, offset, animalType]) async {
    try {
      final queryParams = {
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString()
      };
      const url = 'http://192.168.20.3:8000/messages';
      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final messages = json.map((e) {
          return Message(
              messageId: e["messageId"],
              title: e['title'],
              description: e["description"]
          );
        }).toList();
        for (int i = 0; i < messages.length; i++) {
          print(messages[i].toJson());
        }
        return messages;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future getMessageById(int messageId) async {
    try {
      final url = 'http://192.168.20.3:8000/message/$messageId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final message = Message(
          messageId: json["messageId"],
          title: json["title"],
          description: json["description"]
        );
        if (response.statusCode == 200) {
          return message;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future makeMessage(Message message) async {
    try {
      const url = 'http://192.168.20.3:8000/message/';
      final uri = Uri.parse(url);
      final body = {
        "title": message.title,
        "description": message.description
      };
      print(body);
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

  Future deleteMessage(int messageId) async {
    try {
      final url = 'http://192.168.20.3:8000/message/$messageId';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future editMessage(Message message, int messageId) async {
    try {
      final url = 'http://192.168.20.3:8000/message/$messageId';
      final uri = Uri.parse(url);
      final body = {
        "title": message.title,
        "description": message.description
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
