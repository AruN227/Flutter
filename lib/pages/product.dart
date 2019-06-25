import 'package:flutter/material.dart';
import 'dart:async';
import '../models/product.dart';
import 'package:map_view/map_view.dart';

class ProductPage extends StatelessWidget {
  final Product product;
  //final String productId;
  ProductPage(this.product);


  void _showMap() {
    final List<Marker> markers = <Marker>[
      Marker('position', 'Position', product.location.latitude,
          product.location.longitude)
    ];
    final cameraPosition = CameraPosition(
        Location(product.location.latitude, product.location.longitude), 14.0);
    final mapView = MapView();
    mapView.show(
        MapOptions(
            initialCameraPosition: cameraPosition,
            mapViewType: MapViewType.normal,
            title: 'Product Location'),
        toolbarActions: [
          ToolbarAction('Close', 1),
        ]);
    mapView.onToolbarAction.listen((int id) {
      if (id == 1) {
        mapView.dismiss();
      }
    });
    mapView.onMapReady.listen((_) {
      mapView.setMarkers(markers);
    });
  }

  Widget _buildAddressRow(String address,double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: _showMap,
        child: Text(
          address,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),),
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FadeInImage(
              image: NetworkImage(product.image),
              height: 300.0,
              fit: BoxFit.fill,
              placeholder: AssetImage('assets/cake.jpg'),
            ),
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
            _buildAddressRow(product.location.address ,product.price),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
