import 'package:flutter/material.dart';
import 'package:firearm_flutter/pages/add_cart.dart';
import 'package:firearm_flutter/pages/edit_cart.dart';
import 'package:firearm_flutter/models/cart_model.dart';
import 'package:firearm_flutter/widgets/cart_card.dart';
import 'package:firearm_flutter/services/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartModel> cartItems = [];
  bool isLoading = true;
  int userId = 1;
  
  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  Future<void> _fetchCart() async {
    setState(() => isLoading = true);
    try {
      final data = await CartService.getCartItems(userId);
      setState(() => cartItems = data);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _handleCheckout() async {
    setState(() => isLoading = true);
    final success = await CartService.checkout(userId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Checkout Berhasil!")),
      );
      _fetchCart();
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: isLoading ? const Center(child: CircularProgressIndicator()): cartItems.isEmpty ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("The cart is empty"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCart())),
              child: const Text("Start Shopping"),
            ),
          ],
        ),
      ): 
      ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return CartCard(
            cart: item,
            onDelete: () async {
              await CartService.deleteCartItem(item.id!);
              _fetchCart();
            },
            onEdit: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCard(cart: item),
                ),
              );
              _fetchCart();
            },
          );
        },
      ),
      floatingActionButton: cartItems.isEmpty ? null: FloatingActionButton.extended(
        onPressed: _handleCheckout,
        label: const Text("Checkout"),
        icon: const Icon(Icons.payment),
      ),
    );
  }
}