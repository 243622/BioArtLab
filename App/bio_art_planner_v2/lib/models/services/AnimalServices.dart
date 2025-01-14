import 'dart:convert';
import '/models/classes/Animal.dart';
import '/models/services/AnimalTypeServices.dart';
import 'package:http/http.dart' as http;
import "package:intl/intl.dart";

class AnimalServices {
  final _animalTypeServices = AnimalTypeServices();

  Future<List<Animal>> getAll([limit, offset, animalType]) async {
    try {
      final queryParams = {
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString(),
        if (animalType != null) 'AnimalType': animalType.toString()
      };
      const url = 'http://192.168.20.3:8000/animals';
      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        var dateFormat = DateFormat("yyyy-MM-dd");

        final animals = json.map((e) {
          return Animal(
              animalId: e['animalId'],
              name: e['name'],
              animalTypeId: e['animalTypeId'] ?? 0,
              birthDate: e['birthDate'] != null
                  ? DateTime.parse(e['birthDate'])
                  : null,
              // Parse if not null
              sicknesses: e['sicknesses'],
              description: e['description']);
        }).toList();
        for (int i = 0; i < animals.length; i++) {
          var responseToDecode = await _animalTypeServices
              .getAnimalTypeById(animals[i].animalTypeId!);
          animals[i].animalTypeInString = responseToDecode?.name.toString();
        }
        return animals;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future getAnimalById(int animalId) async {
    try {
      final url = 'http://192.168.20.3:8000/animal/$animalId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return response;
      }
    } catch (e) {
      print(e);
    }
  }

  Future makeAnimal(Animal animal) async {
    try {
      const url = 'http://192.168.20.3:8000/animal/';
      final uri = Uri.parse(url);
      final body = {
        "name": animal.name,
        "animalTypeId": animal.animalTypeId,
        'birthDate': animal.birthDate?.toIso8601String(),
        'sicknesses': animal.sicknesses,
        'description': animal.description
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

  Future deleteAnimal(int animalId) async {
    try {
      final url = 'http://192.168.20.3:8000/animal/$animalId';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future editAnimal(Animal animal, int animalId) async {
    try {
      final url = 'http://192.168.20.3:8000/animal/$animalId';
      final uri = Uri.parse(url);
      final body = {
        "name": animal.name,
        "animalTypeId": animal.animalTypeId,
        'birthDate': animal.birthDate?.toIso8601String(),
        'sicknesses': animal.sicknesses,
        'description': animal.description
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
