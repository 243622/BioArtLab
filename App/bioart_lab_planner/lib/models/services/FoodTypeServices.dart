import 'dart:convert';
import 'package:bioartlab_planner/models/classes/FoodType.dart';
import 'package:http/http.dart' as http;

class FoodTypeServices {
  Future<List<FoodType>> getAll([limit, offset]) async {
    try {
      final queryParams = {
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString()
      };
      const url = 'http://127.0.0.1:8000/foodtypes';
      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final foodTypes = json.map((e) {
          return FoodType(foodTypeId: e["foodTypeId"], name: e['name']);
        }).toList();
        for (int i = 0; i < foodTypes.length; i++) {
          print(foodTypes[i].toJson());
        }
        return foodTypes;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future getFoodTypeById(int foodTypeId) async {
    try {
      final url = 'http://127.0.0.1:8000/foodtype/${foodTypeId}';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final foodType =
            FoodType(foodTypeId: json["foodTypeId"], name: json["name"]);
        return foodType;
      }
    } catch (e) {
      print(e);
    }
  }

  Future makeFoodType(FoodType foodType) async {
    try {
      const url = 'http://127.0.0.1:8000/foodtype/';
      final uri = Uri.parse(url);
      final body = {'name': foodType.name};
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

  Future deleteFoodType(int foodTypeId) async {
    try {
      final url = 'http://127.0.0.1:8000/foodtype/${foodTypeId}';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future editFoodType(FoodType foodType, int foodTypeId) async {
    try {
      final url = 'http://127.0.0.1:8000/foodtype/${foodTypeId}';
      final uri = Uri.parse(url);
      final body = {"name": foodType.name};
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
