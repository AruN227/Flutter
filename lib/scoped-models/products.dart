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

  String get selectedProductId {
    return selProductId;
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(products);
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return products.firstWhere((Product product) {
      return product.id == selProductId;
    });
  }

  int get selectedProductIndex {
    return products.indexWhere((Product product) {
      return product.id == selProductId;
    });
  }

  bool get displayFavorites {
    return _showFavorites;
  }

  Future<bool> deleteProduct() {
    isLoading1 = true;
    final deletedProductId = selectedProduct.id;
    products.removeAt(selectedProductIndex);
    selProductId = null;
//    notifyListeners();
    return http
        .delete(
            'https://flutter-products-252ef.firebaseio.com/products/${deletedProductId}.json?auth=${authenticatedUser.token}')
        .then((http.Response response) {
      isLoading1 = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading1 = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    isLoading1 = true;
    notifyListeners();
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
            'https://flutter-products-252ef.firebaseio.com/products/${selectedProduct.id}.json?auth=${authenticatedUser.token}',
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
      selProductId = null;
      notifyListeners();
      return true;
    }).catchError((error) {
      isLoading1 = false;
      notifyListeners();
      return false;
    });
  }

  void selectProduct(String productId) {
    selProductId = productId;
    notifyListeners();
  }

  void favoriteProduct() async {
    final bool isCurrentFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentFavorite;
    final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: newFavoriteStatus);
      products[selectedProductIndex] = updatedProduct;
      //selProductId = null;
      notifyListeners();
    http.Response response;
    if (newFavoriteStatus) {
      response = await http.put(
          'https://flutter-products-252ef.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${authenticatedUser.id}.json?auth=${authenticatedUser.token}',
          body: json.encode(true));
    } else {
      response = await http.delete(
          'https://flutter-products-252ef.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${authenticatedUser.id}.json?auth=${authenticatedUser.token}');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: !newFavoriteStatus);
      products[selectedProductIndex] = updatedProduct;
      selProductId = null;
      notifyListeners();
    }
  }

  void displayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
