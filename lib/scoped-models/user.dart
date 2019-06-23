//import 'package:scoped_model/scoped_model.dart';
//import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import '../models/user.dart';
import './connected_product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';



mixin UserModel on ConnectedProductModels {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  PublishSubject<bool> get userSubject {
    return _userSubject;
  } 
  User get user {
    return authenticatedUser;
  }
  Future<Map<String, dynamic>> login(String email, String password) async {
    isLoading1 = true;
    notifyListeners();
    //authenticatedUser = User(id: 'qsnskaw', email: email, password: password);
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final http.Response response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyAez9w2czaH8SbHQBsrBEMJ4pYpBi60fvM',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});


    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    if (responseData.containsKey('idToken')) {
      message = 'Authentication success';
      hasError = false;
      authenticatedUser = User(id: responseData['localId'],email: email,token: responseData['idToken']);
      //authenticatedUser = User(id: responseData['localId'],email: email,token: responseData['idToken']);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('token', responseData['idToken']);
      pref.setString('userEmail', email);
      pref.setString('userId', responseData['localId']);
      pref.setString('expiryTime', expiryTime.toIso8601String());

    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This Email was not found';
    }
    else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'invalid password';
    }
    //print(json.decode(response.body));
    isLoading1 = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};

  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    isLoading1 = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final http.Response response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyAez9w2czaH8SbHQBsrBEMJ4pYpBi60fvM',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    if (responseData.containsKey('idToken')) {
      message = 'Authentication success';
      hasError = false;
      print(responseData);
      authenticatedUser = User(id: responseData['localId'],email: email,token: responseData['idToken']);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('token', responseData['idToken']);
      pref.setString('userEmail', email);
      pref.setString('userId', responseData['localId']);
      pref.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This Email alredy exists';
    }
    //print(json.decode(response.body));
    isLoading1 = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
    
  }

  void autoAuthenticate() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String token = pref.getString('token');
    final String expiryTimeString = pref.getString('expiryTime');  
    print(expiryTimeString); 
    if(token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      print(parsedExpiryTime);
      if (parsedExpiryTime.isBefore(now)) {
        authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = pref.getString('userEmail');
      final String userId = pref.getString('userId');
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      authenticatedUser = User(id: userId,email: userEmail,token: token);
      _userSubject.add(true);
       setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

   void logout() async {
     print('logout');
    authenticatedUser = null;
   _authTimer.cancel();
   _userSubject.add(false);
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
    pref.remove('userEmail');
    pref.remove('userId');
  }

  void setAuthTimeout(int time) {
   _authTimer = Timer(Duration(seconds: time), logout);
  }
}
