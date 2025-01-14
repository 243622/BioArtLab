import 'dart:convert';
import 'package:bioartlab_planner/models/classes/Stock.dart';
import 'package:bioartlab_planner/models/services/FoodTypeServices.dart';
import 'package:http/http.dart' as http;

class StockServices {
  final _foodTypeService = FoodTypeServices();

  Future<List<Stock>> getAll([limit, offset]) async {
    try {
      final queryParams = {
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString()
      };
      const url = 'http://127.0.0.1:8000/stocks';
      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final stocks = json.map((e) {
          return Stock(
              stockId: e['stockId'],
              quantity: e['quantity'],
              foodTypeId: e['foodTypeId'] ?? 0,
              minimumQuantity: e['minimumQuantity']);
        }).toList();
        for (int i = 0; i < stocks.length; i++) {
          var responseToDecode =
              await _foodTypeService.getFoodTypeById(stocks[i].foodTypeId!);
          stocks[i].foodTypeInString = responseToDecode?.name.toString();
        }
        return stocks;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future getStockById(int stockId) async {
    try {
      final url = 'http://127.0.0.1:8000/stock/${stockId}';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return response;
      }
    } catch (e) {
      print(e);
    }
  }

  Future makeStock(Stock stock) async {
    try {
      const url = 'http://127.0.0.1:8000/stock/';
      final uri = Uri.parse(url);
      final body = {
        'quantity': stock.quantity,
        'foodTypeId': stock.foodTypeId,
        'minimumQuantity': stock.minimumQuantity
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

  Future deleteStock(int stockId) async {
    try {
      final url = 'http://127.0.0.1:8000/stock/${stockId}';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future editStock(Stock stock, int stockId) async {
    try {
      final url = 'http://127.0.0.1:8000/stock/${stockId}';
      final uri = Uri.parse(url);
      final body = {
        'quantity': stock.quantity,
        'foodTypeId': stock.foodTypeId,
        'minimumQuantity': stock.minimumQuantity
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
