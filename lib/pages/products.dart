import 'package:flutter/material.dart';
import '../widgets/products/products.dart';
//import './products_admin.dart';
import '../scoped-models/products.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsPage extends StatelessWidget {
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage products'),
            onTap: () => Navigator.pushReplacementNamed(context, '/admin'),
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
          ScopedModelDescendant<ProductsModels>(builder:
              (BuildContext context, Widget child, ProductsModels model) {
            return IconButton(
              icon: Icon(model.displayFavorites
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                model.displayMode();
              },
            );
          })
        ],
      ),
      body: Products(),
    );
  }
}
