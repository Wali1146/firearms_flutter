import 'package:flutter/material.dart';
import 'package:firearm_flutter/models/product_model.dart';
import 'package:firearm_flutter/services/api_service.dart';

class EditProduct extends StatefulWidget {
  final Product product;
  const EditProduct({super.key, required this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Product")),
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
                await ApiService.updateProduct(
                  widget.product.id,
                  Product(
                    id: widget.product.id,
                    name: nameController.text,
                    type: widget.product.type,
                    categoryId: widget.product.categoryId,
                    teamId: widget.product.teamId,
                    price: double.parse(priceController.text),
                    description: widget.product.description,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Product successfully updated")),
                );
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
