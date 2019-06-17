import 'package:flutter/material.dart';
//import './pages/product.dart';
class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function deleteProduct;

  Products(this.products,{this.deleteProduct});

  Widget _buildProductItem(BuildContext context, int index) {
   return  Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset(products[index]['image']),
                      Text(products[index]['title']),
                      ButtonBar(alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(child: Text('Next Page'),
                        onPressed: () => Navigator.pushNamed<bool>(context, '/product/' + index.toString()),
                        
                        )
                      ],)
                    ],
                  ),
                );
  }

  Widget _buildProductList() {
    return products.length >0 ?ListView.builder(
      itemBuilder: _buildProductItem,
      itemCount: products.length
    ): Center(child: Text('No products found, Please add some'),);
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList(); 
  }
}
