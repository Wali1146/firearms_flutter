class Product {
  final int id;
  final String name;
  final String type;
  final int categoryId;
  final int teamId;
  final double price;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.categoryId,
    required this.teamId,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()),
      name: json['name'] as String,
      type: json['type'] as String,
      categoryId: int.parse(json['category_id'].toString()),
      teamId: int.parse(json['team_id'].toString()),
      price: double.parse(json['price'].toString()),
      description: json['description'] as String,
    );
  }
}