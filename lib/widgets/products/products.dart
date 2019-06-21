import 'package:flutter/material.dart';
import './price_tag.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';
import '../../models/product.dart';

//import './pages/product.dart';
class Products extends StatelessWidget {
  final Function deleteProduct;

  Products({this.deleteProduct});

  Widget _buildProductItem(BuildContext context, int index) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Card(
          child: Column(
            children: <Widget>[
              FadeInImage(
                image: NetworkImage(model.products[index].image),
                height: 300.0,
                fit: BoxFit.fill,
                placeholder: AssetImage('assets/cake.jpg'),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      model.products[index].title,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    PriceTag(model.products[index].price.toString()),
                  ],
                ),
              ),
              // Text(model.products[index].userEmail),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: Colors.green, width: 1.0),
                ),
                child: Text('Chocolate'),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    //child: Text('Next Page'),
                    icon: Icon(Icons.info),
                    color: Colors.blue,
                    onPressed: () => Navigator.pushNamed<bool>(
                        context, '/product/' + index.toString()),
                  ),
                  ScopedModelDescendant<MainModel>(
                    builder: (BuildContext context, Widget children,
                        MainModel model) {
                      return IconButton(
                        icon: Icon(model.products[index].isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border),
                        color: Colors.red,
                        onPressed: () {
                          model.selectProduct(index);
                          model.favoriteProduct();
                        },
                      );
                    },
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductList(List<Product> products) {
    return products.length > 0
        ? ListView.builder(
            itemBuilder: _buildProductItem, itemCount: products.length)
        : Center(
            child: Text('No products found, Please add some'),
          );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildProductList(model.displayedProducts);
      },
    );
  }
}
