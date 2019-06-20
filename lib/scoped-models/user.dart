import 'package:scoped_model/scoped_model.dart';
import '../models/user.dart';
import './connected_product.dart';

mixin UserModel on ConnectedProductModels {

  void login(String email, String password) {
    authenticatedUser = User(id: 'qsnskaw',email: email,password: password);
  }
}