import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

mixin ConnectedProductModels on Model {
  List<Product> products = [];
  User authenticatedUser;
  int selProductIndex;
  bool isLoading1 = false;

  Future<Null> addProduct(
      String title, String description, String image, double price) {
    isLoading1 = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://assets.kraftfoods.com/recipe_images/opendeploy/74034_640x428.jpg',
      'price': price,
      'userEmail': authenticatedUser.email,
      'userId': authenticatedUser.id,
    };
    return http
        .post('https://flutter-products-252ef.firebaseio.com/products.json',
            body: json.encode(productData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: authenticatedUser.email,
          userId: authenticatedUser.id);
      products.add(newProduct);
      selProductIndex = null;
      isLoading1 = false;
      notifyListeners();
    });
  }

  Future<Null> fetchProducts() {
    isLoading1 = true;
    notifyListeners();
    return http
        .get('https://flutter-products-252ef.firebaseio.com/products.json')
        .then((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        isLoading1 = false;
        notifyListeners();
        return;
      }

      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['image'],
            price: productData['price'],
            userEmail: productData['userEmail'],
            userId: productData['userId']);
        fetchedProductList.add(product);
      });
      products = fetchedProductList;
      isLoading1 = false;
      notifyListeners();
    });
  }
}

mixin UtilityModel on ConnectedProductModels {
  bool get isLoading {
    return isLoading1;
  }
}
