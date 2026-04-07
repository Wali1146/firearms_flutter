import 'package:flutter/material.dart';
import 'package:firearm_flutter/models/cart_model.dart';
import 'package:firearm_flutter/services/cart_service.dart';

class EditCard extends StatefulWidget {
  final CartModel cart;
  const EditCard({super.key, required this.cart});

  @override
  State<EditCard> createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  late TextEditingController qtyController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    qtyController = TextEditingController(text: widget.cart.quantity.toString());
  }

  Future<void> _updateCart() async {
    if (qtyController.text.isEmpty) return;
    setState(() => isLoading = true);
    CartModel updatedItem = CartModel(
      id: widget.cart.id,
      userId: widget.cart.userId,
      productId: widget.cart.productId,
      quantity: int.parse(qtyController.text),
      status: widget.cart.status,
    );
    try {
      await CartService.updateCartItem(widget.cart.id!, updatedItem);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengupdate keranjang")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Quantity")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Product ID: ${widget.cart.productId}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Quantity",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _updateCart,
                child: isLoading ? const CircularProgressIndicator(): 
                const Text("Update Keranjang"),
              ),
            )
          ],
        ),
      ),
    );
  }
}