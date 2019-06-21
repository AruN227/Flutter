import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {
  final int productIndex;
  ProductPage(this.productIndex);

  Widget _buildAddressRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Chennai, TN',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          price.toString(),
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 20.0),
        ),
      ],
    );
  }

  // _showWarningDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Are you sure?'),
  //           content: Text('This action cannot be undone!'),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('DISCARD'),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             FlatButton(
  //               child: Text('CONTINUE'),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 Navigator.pop(context, true);
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      Navigator.pop(context, false);
      return Future.value(false);
    }, child: ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Product product = model.products[productIndex];
        return Scaffold(
          appBar: AppBar(
            title: Text(product.title),
          ),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network(product.image),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // ButtonTheme(
              //   minWidth: 400.0,
              //   height:50.0,
              //   padding: EdgeInsets.all(10.0),
              //   child: RaisedButton(
              //     child: Text('Delete'),
              //     onPressed: () => _showWarningDialog(context),
              //   ),
              // ),
              _buildAddressRow(product.price),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
