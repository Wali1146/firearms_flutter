import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firearm_flutter/config/config.dart';
import 'package:firearm_flutter/models/product_model.dart';

class ApiService {
  static final String baseUrl = Config.baseUrl;

  // GET (READ)
  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse("$baseUrl/products"));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) {
        return decoded.map((e) => Product.fromJson(e)).toList();
      } else if (decoded is Map && decoded.containsKey('data')) {
        final List data = decoded['data'];
        return data.map((e) => Product.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load products");
    }
  }

  // POST (CREATE)
  static Future<void> addProduct(Product product) async {
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
      throw Exception("Failed to add product");
    }
  }

  // PUT (UPDATE)
  static Future<void> updateProduct(int id, Product product) async {
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
      throw Exception("Failed to update product");
    }
  }

  // DELETE
  static Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/products/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete product");
    }
  }
}
