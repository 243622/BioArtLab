import 'dart:convert';
import 'package:bio_art_planner_v2/models/classes/FoodType.dart';
import 'package:bio_art_planner_v2/models/classes/many_many/Foodtype_Animal.dart';
import 'package:bio_art_planner_v2/models/services/AnimalTypeServices.dart';
import 'package:bio_art_planner_v2/models/services/FoodTypeServices.dart';

import '../../classes/AnimalType.dart';
import 'package:http/http.dart' as http;

class FoodTypeAnimalServices {


  // om foodtypes op te halen
  Future getFoodTypeAnimalTypeByAnimalTypeId(int animaTypeId) async {
    try {
      final url = 'http://192.168.20.3:8000/foodtypeanimal/$animaTypeId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final json = jsonDecode(response.body) as List;
      final foodTypeAnimals = json.map((e) {
        return FoodtypeAnimal(
          foodTypesAnimalsId: e['foodTypesAnimalsId'],
          foodTypeId: e['foodTypeId'] ?? '',
          animalTypeId: e['animalTypeId'] ?? '',
        );
      }).toList();
      AnimalTypeServices animalTypeServices = AnimalTypeServices();
      FoodTypeServices foodTypeServices = FoodTypeServices();
      late AnimalType animalType;
      List<FoodType> foodTypes = [];
      animalType = await animalTypeServices.getAnimalTypeById(animaTypeId);
      for(var i = 0; i < foodTypeAnimals.length; i++){
        foodTypes.add(await foodTypeServices.getFoodTypeById(foodTypeAnimals[i].foodTypeId));
      }
      if (response.statusCode == 200) {
        return {
          "response": response.body,
          "animalType": animalType,
          "foodTypes": foodTypes
        };
      }
    } catch (e) {
      print(e);
    }
  }

  //Om animaltypes op te halen
  Future getAnimalTypesByFoodTypeId(int foodTypeId) async {
    try {
      final url = 'http://192.168.20.3:8000/animalfoodtype/$foodTypeId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final json = jsonDecode(response.body) as List;
      final animalFoodTypes = json.map((e) {
        return FoodtypeAnimal(
          foodTypesAnimalsId: e['foodTypesAnimalsId'],
          foodTypeId: e['foodTypeId'] ?? '',
          animalTypeId: e['animalTypeId'] ?? '',
        );
      }).toList();
      AnimalTypeServices animalTypeServices = AnimalTypeServices();
      FoodTypeServices foodTypeServices = FoodTypeServices();
      late FoodType foodType;
      List<AnimalType> animalTypes = [];
      foodType = await foodTypeServices.getFoodTypeById(foodTypeId);
      for(var i = 0; i < animalFoodTypes.length; i++){
        animalTypes.add(await animalTypeServices.getAnimalTypeById(animalFoodTypes[i].animalTypeId));
      }
      if (response.statusCode == 200) {
        return {
          "response": response.body,
          "foodType": foodType,
          "animalTypes": animalTypes
        };
      }
    } catch (e) {
      print(e);
    }
  }

  Future makeFoodTypeAnimal(FoodtypeAnimal foodTypeAnimal) async {
    try {
      const url = 'http://192.168.20.3:8000/foodtypeanimal/';
      final uri = Uri.parse(url);
      final body = {
        "foodTypeId": foodTypeAnimal.foodTypeId,
        "animalTypeId": foodTypeAnimal.animalTypeId
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

  Future deleteFoodTypeAnimal(int foodTypeAnimalId) async {
    try {
      final url = 'http://192.168.20.3:8000/foodtypeanimal/$foodTypeAnimalId';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future editFoodTypeAnimal(FoodtypeAnimal foodTypeAnimal, int foodTypeAnimalId) async {
    try {
      final url = 'http://192.168.20.3:8000/foodtypeanimal/$foodTypeAnimalId';
      final uri = Uri.parse(url);
      final body = {
        "foodTypeId": foodTypeAnimal.foodTypeId,
        "animalTypeId": foodTypeAnimal.animalTypeId
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
