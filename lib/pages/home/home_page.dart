import 'package:flutter/material.dart';
import 'package:firearm_flutter/pages/add_product.dart';
import 'package:firearm_flutter/pages/edit_product.dart';
import 'package:firearm_flutter/models/product_model.dart';
import 'package:firearm_flutter/services/api_service.dart';
import 'package:firearm_flutter/widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  bool isLoading = true;
  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    try {
      final result = await ApiService.getProducts();
      products = result ?? [];
    } catch (e) {
      products = [];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load products")));
    }
    setState(() => isLoading = false);
  }
  
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("products")),
      body: isLoading? Center(child: CircularProgressIndicator()): 
      RefreshIndicator(
        onRefresh: fetchProducts,
        child: ListView.builder(
          itemCount: products.isEmpty ? 0 : products.length,
          itemBuilder: (context, index) {
            return ProductCard(
              product: products[index],

              //Edit Product
              onEdit: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProduct(product: products[index]),
                  ),
                );
                if (result == true) {await fetchProducts();}
              },

              //Delete Product
              onDelete: () async {
                final confirm = await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Delete Product"),
                    content: Text("Are you sure to delete this product?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("No, i'am not sure"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text("Yes, i'am sure"),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  final deletedProduct = products[index];
                  setState(() {products.removeAt(index);});
                  try {
                    await ApiService.deleteProduct(deletedProduct.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Product successfully deleted")),
                    );
                  } catch (e) {
                    setState(() {
                      products.insert(index, deletedProduct);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to delete product")),
                    );
                  }
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddProduct()),
          );
          if (result == true) {
            await fetchProducts();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
