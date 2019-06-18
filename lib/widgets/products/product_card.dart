import 'package:flutter/material.dart';
import 'price_tag.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final double productIndex;

  ProductCard(this.product,this.productIndex);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product['image']),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  product['title'],
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10.0,
                ),
                PriceTag(product['price'].toString()),
              ],
            ),
          ),
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
                    context, '/product/' + productIndex.toString()),
              ),
              IconButton(
                //child: Text('Next Page'),
                icon: Icon(Icons.favorite_border),
                color: Colors.red,
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/product/' + productIndex.toString()),
              )
            ],
          )
        ],
      ),
    );;
  }
}