import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firearm_flutter/config/config.dart';
import 'package:firearm_flutter/models/cart_model.dart';

class CartService {
  static final String baseUrl = Config.baseUrl;

  // GET (READ)
  static Future<List<CartModel>> getCartItems(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/cart/user/$userId"));
    print("Response: ${response.body}");
    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body);
      return decoded.map((e) => CartModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  // POST (CREATE)
  static Future<bool> addToCart(CartModel cartItem) async {
    final response = await http.post(
      Uri.parse("$baseUrl/cart"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "user_id": cartItem.userId,
        "product_id": cartItem.productId,
        "quantity": cartItem.quantity,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // CHECKOUT
  static Future<bool> checkout(int userId) async {
    final response = await http.post(Uri.parse("$baseUrl/cart/checkout/$userId"));
    return response.statusCode == 200;
  }

  // PUT (UPDATE)
  static Future<void> updateCartItem(int id, CartModel cartItem) async {
    final response = await http.put(
      Uri.parse("$baseUrl/cart/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "user_id": cartItem.userId,
        "product_id": cartItem.productId,
        "quantity": cartItem.quantity,
        "status": cartItem.status,
      }),
    );
    print("Response Update Cart: ${response.body}");
  }

  // DELETE
  static Future<void> deleteCartItem(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/cart/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete cart item");
    }
  }
}