import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import './connected_product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

mixin ProductsModels on ConnectedProductModels {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(products);
  }

  int get selectedProductIndex {
    return selProductIndex;
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(products);
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return products[selectedProductIndex];
  }

  bool get displayFavorites {
    return _showFavorites;
  }

  void deleteProduct() {

    isLoading1 = true;
    final deletedProductId = selectedProduct.id;
    products.removeAt(selectedProductIndex);
    selProductIndex = null;
//    notifyListeners();
    http
        .delete(
            'https://flutter-products-252ef.firebaseio.com/products/${deletedProductId}.json')
        .then((http.Response response) {
      isLoading1 = false;    
      notifyListeners();
    });

    notifyListeners();
  }

  Future<Null> updateProduct(
      String title, String description, String image, double price) {
    isLoading1 = true;
    //notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'https://assets.kraftfoods.com/recipe_images/opendeploy/74034_640x428.jpg',
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };
    return http
        .put(
            'https://flutter-products-252ef.firebaseio.com/products/${selectedProduct.id}.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      isLoading1 = false;
      notifyListeners();
      final Product updateProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      products[selectedProductIndex] = updateProduct;
      selProductIndex = null;
      notifyListeners();
    });
  }

  void selectProduct(int index) {
    selProductIndex = index;
    notifyListeners();
  }

  void favoriteProduct() {
    final bool isCurrentFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentFavorite;
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    products[selectedProductIndex] = updatedProduct;
    notifyListeners();
    selProductIndex = null;
  }

  void displayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
