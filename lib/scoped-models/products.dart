import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import './connected_product.dart';

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
    products.removeAt(selectedProductIndex);
    selProductIndex = null;
    notifyListeners();
  }

  void updateProduct(String title, String description, String image, double price) {
    final Product updateProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    products[selectedProductIndex] = updateProduct;
    selProductIndex = null;
    notifyListeners();
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
