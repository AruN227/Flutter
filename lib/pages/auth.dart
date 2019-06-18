import 'package:flutter/material.dart';
import './products.dart';

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

  DecorationImage _buildBgImage() {
    return DecorationImage(
      image: AssetImage('assets/food.jpg'),
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        filled: true,
        //fillColor: Colors.white
      ),
      keyboardType: TextInputType.emailAddress,
      onChanged: (String value) {
        setState(() {
          _email = value;
        });
      },
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        // fillColor: Colors.white
      ),
      obscureText: true,
      onChanged: (String value) {
        setState(() {
          _password = value;
        });
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _acceptTerms,
      onChanged: (bool value) {
        setState(() {
          _acceptTerms = value;
        });
      },
      title: Text('Accept Terms and Conditions'),
    );
  }

  void _submitForm() {
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
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
                RaisedButton(
                  child: Text('Login'),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
