import 'package:scoped_model/scoped_model.dart';
import './products.dart';
import './connected_product.dart';
import './user.dart';

class MainModel extends Model with ConnectedProductModels,UserModel,ProductsModels,UtilityModel {

}