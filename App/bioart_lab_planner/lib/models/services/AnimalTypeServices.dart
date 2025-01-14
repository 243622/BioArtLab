import 'dart:convert';
import 'package:bioartlab_planner/models/classes/AnimalType.dart';
import 'package:http/http.dart' as http;

class AnimalTypeServices {
  Future<List<AnimalType>> getAll([limit, offset]) async {
    try {
      final queryParams = {
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString()
      };
      const url = 'http://127.0.0.1:8000/animaltypes';
      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final animalTypes = json.map((e) {
          return AnimalType(animalTypeId: e['animalTypeId'], name: e['name']);
        }).toList();
        for (int i = 0; i < animalTypes.length; i++) {}
        return animalTypes;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future getAnimalTypeById(int animalTypeId) async {
    try {
      final url = 'http://127.0.0.1:8000/animaltype/${animalTypeId}';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final animalType =
            AnimalType(animalTypeId: json["animalTypeId"], name: json["name"]);
        return animalType;
      }
    } catch (e) {
      print(e);
    }
  }

  Future makeAnimalType(AnimalType animalType) async {
    try {
      const url = 'http://127.0.0.1:8000/animaltype/';
      final uri = Uri.parse(url);
      final body = {'name': animalType.name};
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

  Future deleteAnimalType(int animalTypeId) async {
    try {
      final url = 'http://127.0.0.1:8000/animaltype/${animalTypeId}';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future editAnimalType(AnimalType animalType, int animalTypeId) async {
    try {
      final url = 'http://127.0.0.1:8000/animaltype/${animalTypeId}';
      final uri = Uri.parse(url);
      final body = {"name": animalType.name};
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
