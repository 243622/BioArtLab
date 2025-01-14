import 'dart:convert';
import 'package:bioartlab_planner/models/classes/Rapport.dart';
import 'package:http/http.dart' as http;

class RapportServices {
  Future<List<Rapport>> getAll([limit, offset]) async {
    try {
      final queryParams = {
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString()
      };
      const url = 'http://127.0.0.1:8000/rapports';
      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final rapports = json.map((e) {
          return Rapport(
              taskId: e['taskId'],
              title: e['title'],
              description: e['description'],
              photos: e['photos'],
              exceptionalities: e['exceptionalities'],
              date: e['date']);
        }).toList();
        for (int i = 0; i < rapports.length; i++) {
          print(rapports[i].toJson());
        }
        return rapports;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future getRapportById(int rapportId) async {
    try {
      final url = 'http://127.0.0.1:8000/rapport/${rapportId}';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return response;
      }
    } catch (e) {
      print(e);
    }
  }

  Future makeRapport(Rapport rapport) async {
    try {
      const url = 'http://127.0.0.1:8000/rapport/';
      final uri = Uri.parse(url);
      final body = {
        "taskId": rapport.taskId,
        "title": rapport.title,
        'description': rapport.description,
        'photos': rapport.photos,
        'exceptionalities': rapport.exceptionalities,
        'date': rapport.date
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

  Future deleteRapport(int rapportId) async {
    try {
      final url = 'http://127.0.0.1:8000/rapport/${rapportId}';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future editRapport(Rapport rapport, int rapportId) async {
    try {
      final url = 'http://127.0.0.1:8000/rapport/${rapportId}';
      final uri = Uri.parse(url);
      final body = {
        "taskId": rapport.taskId,
        "title": rapport.title,
        'description': rapport.description,
        'photos': rapport.photos,
        'exceptionalities': rapport.exceptionalities,
        'date': rapport.date
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
