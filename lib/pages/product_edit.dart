import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ProductEditPage extends StatefulWidget {
  // final Function addProduct;
  // final Function updateProduct;
  // final Product product;
  // final int productIndex;

  // ProductEditPage({this.addProduct,this.updateProduct,this.product,this.productIndex});

  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  String _titleValue;
  String _descriptionValue;
  double _priceValue;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/cake.jpg',
  };

  Widget _buildTitleTextField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Title'),
      initialValue: product == null ? '' : product.title,
      validator: (String value) {
        if (value.isEmpty || value.length < 3) {
          return 'Title is required and Title should be min 3 char';
        }
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(labelText: 'Product Description'),
      initialValue: product == null ? '' : product.description,
      validator: (String value) {
        if (value.isEmpty || value.length < 3) {
          return 'Description is required and Description should be min 3 char';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildPriceTextTitle(Product product) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Product Price'),
      initialValue:
          product == null ? '' : product.price.toString(),
      // validator: (String value) {
      //   if (value.isEmpty ||
      //       RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
      //     return 'Price is required and should be number';
      //   }
      // },
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  void _submitForm(Function addProduct, Function updateProduct, [int selectedProductIndex]) {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    if (selectedProductIndex == null) {
      addProduct(
             _formData['title'],
            _formData['description'],
            _formData['image'],
            _formData['price'],
      );
    } else {
      updateProduct(
            _formData['title'],
            _formData['description'],
            _formData['image'],
            _formData['price'],
      );
    }

    Navigator.pushReplacementNamed(context, '/products');
  }

  Widget _buildSubmit() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          child: Text('Save'),
          color: Theme.of(context).accentColor,
          textColor: Colors.white,
          onPressed: () => _submitForm(model.addProduct, model.updateProduct,model.selectedProductIndex),
        );
      },
    );
  }

  Widget _buildPageContent(BuildContext context,Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double paddingWidth = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _form,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: paddingWidth / 2),
            children: <Widget>[
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextTitle(product),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmit(),
            ],
          ),
        ),
      ),
    );

  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent = _buildPageContent(context,model.selectedProduct);
        return model.selectedProductIndex == null
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Product'),
                ),
                body: pageContent,
              );
      },
    );
  }
}
