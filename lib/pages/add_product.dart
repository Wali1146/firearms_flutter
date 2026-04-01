import 'package:flutter/material.dart';
import 'package:firearm_flutter/models/product_model.dart';
import 'package:firearm_flutter/services/product_service.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            //Input Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            //Input Price
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            //Button Save
            ElevatedButton(
              onPressed: () async {
                final product = ProductModel(
                  id: 0,
                  name: nameController.text,
                  type: "firearms",
                  categoryId: 1,
                  teamId: 1,
                  price: double.parse(priceController.text),
                  description: "",
                );
                await ProductService.addProduct(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Product successfully added")),
                );
                await ProductService.getProducts();
                Navigator.pop(context, true);
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
