class CartModel {
  final int? id;
  final int userId;
  final int productId;
  final int quantity;
  final String status;

  CartModel({
    this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.status,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      userId: int.parse(json['user_id'].toString()),
      productId: int.parse(json['product_id'].toString()),
      quantity: int.parse(json['quantity'].toString()),
      status: json['status'] ?? 'cart',
    );
  }
}