import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firearm_flutter/config/config.dart';
import 'package:firearm_flutter/models/product_model.dart';

class ApiService {
  static final String baseUrl = Config.baseUrl;

  // GET (READ)
  static Future<List<ProductModel>> getProducts() async {
    try {
      if (kDebugMode) {
        print("API GET: $baseUrl/products");
      }
      final response = await http.get(Uri.parse("$baseUrl/products"));
      
      if (kDebugMode) {
        print("API Response Status: ${response.statusCode}");
        print("API Response Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          return decoded.map((e) => ProductModel.fromJson(e)).toList();
        } else if (decoded is Map && decoded.containsKey('data')) {
          final List data = decoded['data'];
          return data.map((e) => ProductModel.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception("Server returned ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("API Error (getProducts): $e");
      }
      rethrow;
    }
  }

  // POST (CREATE)
  static Future<void> addProduct(ProductModel product) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/products"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": product.name,
          "type": product.type,
          "category_id": product.categoryId,
          "team_id": product.teamId,
          "price": product.price,
          "description": product.description,
        }),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception("Failed to add product: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("API Error (addProduct): $e");
      }
      rethrow;
    }
  }

  // PUT (UPDATE)
  static Future<void> updateProduct(int id, ProductModel product) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/products/$id"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": product.name,
          "type": product.type,
          "category_id": product.categoryId,
          "team_id": product.teamId,
          "price": product.price,
          "description": product.description,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to update product: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("API Error (updateProduct): $e");
      }
      rethrow;
    }
  }

  // DELETE
  static Future<void> deleteProduct(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/products/$id"));
      if (response.statusCode != 200) {
        throw Exception("Failed to delete product: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("API Error (deleteProduct): $e");
      }
      rethrow;
    }
  }
}
