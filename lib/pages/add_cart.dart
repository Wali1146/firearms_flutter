import 'package:flutter/material.dart';
import 'package:firearm_flutter/models/cart_model.dart';
import 'package:firearm_flutter/services/cart_service.dart';

class AddCart extends StatefulWidget {
  const AddCart({super.key});

  @override
  State<AddCart> createState() => _AddCartState();
}

class _AddCartState extends State<AddCart> {
  final int productId = 4;
  final int userId = 1;
  final qtyController = TextEditingController(text: "1");
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add to Cart")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cart Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoTile("Product ID", productId.toString(), Icons.inventory_2),
              const SizedBox(height: 16),
              const Text("Quantity", style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Enter quantity",
                  prefixIcon: Icon(Icons.add_shopping_cart, color: Color(0xFF1E40AF)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleAddToCart,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: isLoading ? const CircularProgressIndicator(color: Colors.white): 
                    const Text("Add to Cart"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF1E40AF)),
              const SizedBox(width: 10),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
  Future<void> _handleAddToCart() async {
    if (qtyController.text.isEmpty || int.parse(qtyController.text) <= 0) {
      _showSnackBar("Please enter a valid quantity");
      return;
    }
    setState(() => isLoading = true);
    try {
      CartModel newCartItem = CartModel(
        userId: userId,
        productId: productId,
        quantity: int.parse(qtyController.text),
        status: 'cart',
      );
      bool success = await CartService.addToCart(newCartItem);
      if (success) {
        _showSnackBar("Added to cart successfully!");
        Navigator.pop(context);
      } else {
        _showSnackBar("Failed to add to cart");
      }
    } catch (e) {
      _showSnackBar("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
