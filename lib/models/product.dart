import 'package:flutter/material.dart';
import './location_data.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final String image;
  final double price;
  final String userEmail;
  final String userId;
  final bool isFavorite;
  LocationData location;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.image,
      @required this.price,
      @required this.userEmail,
      @required this.userId,
      @required this.location,
      this.isFavorite=false});
}
