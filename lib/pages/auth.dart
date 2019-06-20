import 'package:flutter/material.dart';
import './products.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _email;
  String _password;
  bool _acceptTerms = false;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'email':null,
    'password':null,
    'acceptTerms':false
  };

  DecorationImage _buildBgImage() {
    return DecorationImage(
      image: AssetImage('assets/food.jpg'),
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
        filled: true,
        //fillColor: Colors.white
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if(value.isEmpty || value.length < 12) {
          return 'Email should be valid';
        }
      },
      onSaved: (String value) {
          _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        // fillColor: Colors.white
      ),
      obscureText: true,
      validator: (String value) {
        if(value.isEmpty || value.length < 9) {
          return 'Password should be valid and min 8 characters';
        }
      },
      onSaved: (String value) {
          _formData['password'] = value;
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms and Conditions'),
    );
  }

  void _submitForm(Function login) {
    if(!_form.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _form.currentState.save();
    login(_formData['email'],_formData['password']);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: _buildBgImage()
        // ),
        margin: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    _buildEmailField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildPasswordField(),
                    _buildAcceptSwitch(),
                    SizedBox(
                      height: 10.0,
                    ),
                    ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget children, MainModel model) {
                      return RaisedButton(
                      child: Text('Login'),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed:() => _submitForm(model.login),
                    );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
