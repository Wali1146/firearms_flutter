import 'package:flutter/material.dart';
import 'package:firearm_flutter/pages/add_product.dart';
import 'package:firearm_flutter/pages/edit_product.dart';
import 'package:firearm_flutter/models/product_model.dart';
import 'package:firearm_flutter/widgets/product_card.dart';
import 'package:firearm_flutter/services/product_service.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<ProductModel> products = [];
  bool isLoading = true;

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    try {
      final result = await ProductService.getProducts();
      products = result;
    } catch (e) {
      products = [];
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load products")));
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
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No Products Yet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Add your first product to get started",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchProducts,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: products[index],
                        onEdit: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProduct(product: products[index]),
                            ),
                          );
                          if (result == true) {
                            await fetchProducts();
                          }
                        },
                        onDelete: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Delete Product"),
                              content: const Text("Are you sure you want to delete this product?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Color(0xFFDC2626)),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            final deletedProduct = products[index];
                            setState(() {
                              products.removeAt(index);
                            });
                            try {
                              await ProductService.deleteProduct(deletedProduct.id);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Product successfully deleted"),
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                products.insert(index, deletedProduct);
                              });
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Failed to delete product")),
                                );
                              }
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
            MaterialPageRoute(builder: (_) => const AddProduct()),
          );
          if (result == true) {
            await fetchProducts();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
