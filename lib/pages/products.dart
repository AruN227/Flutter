import 'package:flutter/material.dart';
import '../widgets/products/products.dart';
//import './products_admin.dart';

class ProductsPage extends StatelessWidget {
  List<Map<String, dynamic>> products;
// final Function addProduct;
// final Function deleteProduct;

ProductsPage(this.products);

Widget _buildDrawer(BuildContext context) {
  return Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              ListTile(
                leading:Icon(Icons.edit),
                title: Text('Manage products'),
                onTap: () =>Navigator.pushReplacementNamed(context,'/admin'),
              ),
            ],
          ),
        );
}
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        drawer: _buildDrawer(context),
        appBar: AppBar(
          title: Text('Ur Taste'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
            ),
          ],
        ),
        body: Products(products),
      );
  }
}