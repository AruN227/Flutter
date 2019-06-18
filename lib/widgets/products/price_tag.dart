import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final String price;

  PriceTag(this.price);
  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  price,
                  style: TextStyle(fontWeight: FontWeight.bold),            
                  ),
              ],
            ),
          );
  }
}