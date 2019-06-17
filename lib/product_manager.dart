import 'package:flutter/material.dart';

import './products.dart';
import './product_control.dart';

class ProductManager extends StatelessWidget {
//   final Map<String, String> startingProduct;

//   ProductManager({this.startingProduct}) {
//     print('Constructor[PM]');
//   }

//   @override
//   State<StatefulWidget> createState() {
//     return _ProductManagerState();
//   }
// }

// class _ProductManagerState extends State<ProductManager> {
//   List<Map<String, String>> _products = [];

//   @override
//   void initState() {
//     super.initState();
//     if (widget.startingProduct != null) {
//       _products.add(widget.startingProduct);
//     }
    
//   }

List<Map<String, String>> products;
final Function addProduct;
final Function deleteProduct;

ProductManager(this.products,this.addProduct,this.deleteProduct);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          child: ProductControl(addProduct)
        ),
        Expanded(child: Products(products, deleteProduct: deleteProduct))
      ],
    );
  }
}
