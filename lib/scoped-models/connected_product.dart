import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:rxdart/subjects.dart';
import 'dart:async';

mixin ConnectedProductModels on Model {
  List<Product> products = [];
  User authenticatedUser;
  String selProductId;
  bool isLoading1 = false;

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
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
    try {
         final http.Response response = await http
        .post('https://flutter-products-252ef.firebaseio.com/products.json?auth=${authenticatedUser.token}',
            body: json.encode(productData));
          if(response.statusCode != 200 && response.statusCode != 201) {
            isLoading1 = false;
            notifyListeners();
            return false;
          }
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
      selProductId = null;
      isLoading1 = false;
      notifyListeners();
      return true;
    }
    catch (error) {
      isLoading1 = false;
            notifyListeners();
            return false;
    }
    
    // .catchError((error) {
    //   isLoading1 = false;
    //         notifyListeners();
    //         return false;
    // }) ;
  }

  Future<Null> fetchProducts({onlyForUser = false}) {
    isLoading1 = true;
    notifyListeners();
    return http
        .get('https://flutter-products-252ef.firebaseio.com/products.json?auth=${authenticatedUser.token}')
        .then<Null>((http.Response response) {
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
            userId: productData['userId'],
            isFavorite: productData['wishlistUsers'] == null ? false : (productData['wishlistUsers'] as Map<String, dynamic>)
                .containsKey(authenticatedUser.id));
        fetchedProductList.add(product);
      });
      products = onlyForUser ? fetchedProductList.where((Product product) {
        return product.userId == authenticatedUser.id;
      }).toList() : fetchedProductList;
      isLoading1 = false;
       notifyListeners();
      selProductId = null;
      notifyListeners();
    }).catchError((error) {
      isLoading1 = false;
            notifyListeners();
            return;
    });
  }
}

mixin UtilityModel on ConnectedProductModels {
  bool get isLoading {
    return isLoading1;
  }
}
