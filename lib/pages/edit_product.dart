import 'package:flutter/material.dart';
import 'package:firearm_flutter/models/product_model.dart';
import 'package:firearm_flutter/services/product_service.dart';

class EditProduct extends StatefulWidget {
  final ProductModel product;
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
    priceController = TextEditingController(text: widget.product.price.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Product")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            //Product name edit
            Text("Product Name"),
            TextField(controller: nameController),
            SizedBox(height: 10),

            //Price product edit
            Text("Price"),
            TextField(controller: priceController),
            SizedBox(height: 10),

            //Description product edit
            Text("Description"),
            TextField(),
            SizedBox(height: 20),

            //Button Save
            ElevatedButton(
              onPressed: () async {
                await ProductService.updateProduct(
                  widget.product.id,
                  ProductModel(
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
