import 'package:flutter/material.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Map<String,dynamic> product;
  final int productIndex;

  ProductEditPage({this.addProduct,this.updateProduct,this.product,this.productIndex});

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
    'title':null,
    'description':null,
    'price':null,
    'image': 'assets/cake.jpg',
  };

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Title'),
      initialValue: widget.product == null ? '' : widget.product['title'],
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

  Widget _buildDescriptionTextField() {
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(labelText: 'Product Description'),
      initialValue: widget.product == null ? '' : widget.product['description'],
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

  Widget _buildPriceTextTitle() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Product Price'),
      initialValue: widget.product == null ? '' : widget.product['price'].toString(),
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

  void _submitForm() {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    if(widget.product == null) {
      widget.addProduct(_formData);
    }
    else {
      widget.updateProduct(widget.productIndex,_formData);
    }
    
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double paddingWidth = deviceWidth - targetWidth;
    final Widget pageContent = 
      GestureDetector(
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
              _buildTitleTextField(),
              _buildDescriptionTextField(),
              _buildPriceTextTitle(),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                  child: Text('Save'),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  onPressed: _submitForm
                  ),
            ],
          ),
        ),
      ),
    ); 
    return widget.product == null ? pageContent : Scaffold(
      appBar: AppBar(title: Text('Edit Product'),
      ),
      body: pageContent,
    );
  }
}
