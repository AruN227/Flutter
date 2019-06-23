import 'package:flutter/material.dart';
import '../widgets/products/products.dart';
//import './products_admin.dart';
import '../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/ui_elements/logout_list_tile.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;
  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {

  @override
  initState() {
    widget.model.fetchProducts();
    super.initState();
  }
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
          Divider(),
          LogoutListTile(),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return ScopedModelDescendant(builder: (BuildContext context,Widget children, MainModel model) {
      Widget content = Center(child: Text('No products found'));
      if(model.displayedProducts.length > 0 && !model.isLoading) {
        content = Products();
      } else if (model.isLoading) {
        content = Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(onRefresh: model.fetchProducts ,child: content) ;
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Text('Ur Taste'),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(builder:
              (BuildContext context, Widget child, MainModel model) {
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
      body: _buildProductList(),
    );
  }
}
