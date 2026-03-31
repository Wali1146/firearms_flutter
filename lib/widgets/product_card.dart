import 'package:flutter/material.dart';
import 'package:firearm_flutter/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  const ProductCard({super.key, required this.product, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text("Rp ${product.price.toStringAsFixed(0)}"),
      onTap: onEdit,
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
