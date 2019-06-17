import 'package:flutter/material.dart';

import './products.dart';
//import './product_control.dart';

class ProductManager extends StatelessWidget {

List<Map<String, dynamic>> products;


ProductManager(this.products);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [ 
        Expanded(child: Products(products))
      ],
    );
  }
}
