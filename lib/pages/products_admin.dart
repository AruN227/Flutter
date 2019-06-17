import 'package:flutter/material.dart';
//import './products.dart';
import './product_list.dart';
import './product_create.dart';

class ProductsAdmin extends StatelessWidget {

  final Function addProduct;
  final Function deleteProduct;

  ProductsAdmin(this.addProduct,this.deleteProduct);
  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              ListTile(
                title: Text('All products'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/products');
                }),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Manage Product'),
          bottom: TabBar(tabs: <Widget>[
            Tab(
              icon: Icon(Icons.create),
              text: 'create product',   
            ),
            Tab(
              icon: Icon(Icons.list),
              text: 'My Products',
              ),
          ],
          ),
        ),

        
        body: TabBarView(children: <Widget>[
            ProductCreatePage(addProduct),
            ProductListPage()
        ],)
      ),);
  }
}