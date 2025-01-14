import 'dart:convert';

import 'package:bioartlab_planner/models/classes/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserServices {
  Future<List<User>> getAll([limit, offset]) async {
    try {
      final queryParams = {
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString()
      };
      const url = 'http://127.0.0.1:8000/users';
      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final users = json.map((e) {
          return User(
              userId: e['userId'],
              username: e['username'],
              password: e['password'],
              function: e['function']);
        }).toList();
        for (int i = 0; i < users.length; i++) {
          print(users[i].toJson());
        }
        return users;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future getUserById(int userId) async {
    try {
      final url = 'http://127.0.0.1:8000/user/${userId}';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return response;
      }
    } catch (e) {
      print(e);
    }
  }

  Future makeUser(User user) async {
    try {
      const url = 'http://127.0.0.1:8000/user/';
      final uri = Uri.parse(url);
      final body = {
        "username": user.username,
        "password": user.password,
        "function": 0
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

  Future loginUser(String username, String password) async {
    try {
      final url = 'http://127.0.0.1:8000/login';
      final uri = Uri.parse(url);
      final body = {"username": username, "password": password};
      final response = await http.post(uri,
          body: jsonEncode(body),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return;
    } catch (e) {
      print(e);
    }
  }

  Future refreshToken(String username) async {
    try {
      final url = 'http://127.0.0.1:8000/refresh/$username}';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return response;
      }
    } catch (e) {
      print(e);
    }
  }

  Future deleteUser(int userId) async {
    try {
      final url = 'http://127.0.0.1:8000/user/$userId';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future editUser(User user, int userId) async {
    try {
      final url = 'http://127.0.0.1:8000/user/$userId';
      final uri = Uri.parse(url);
      final body = {
        "username": user.username,
        "password": user.password,
        "function": user.function,
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
