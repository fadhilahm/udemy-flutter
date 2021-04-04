import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../models/product_form.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = ProductForm(
    title: '',
    price: 0.0,
    description: '',
    imageUrl: '',
  );
  final _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };
  var _isInit = false;
  var _isEdit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _editedProduct.id = product.id;
        _editedProduct.title = product.title;
        _editedProduct.price = product.price;
        _editedProduct.description = product.description;
        _editedProduct.imageUrl = product.imageUrl;
        _initValues['title'] = _editedProduct.title;
        _initValues['price'] = _editedProduct.price.toString();
        _initValues['description'] = _editedProduct.description;
        _initValues['imageUrl'] = _editedProduct.imageUrl;
        _imageUrlController.text = _initValues['imageUrl'];
      } else {
        _isEdit = false;
      }
    }
    _isInit = true;
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlController.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty) setState(() {});
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) return;
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();

    final products = Provider.of<Products>(context, listen: false);
    setState(() => _isLoading = true);
    try {
      _isEdit
          ? await products.editProduct(_editedProduct.id, _editedProduct)
          : await products.addProduct(_editedProduct);
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occured!'),
          content: const Text('Something went wrong!'),
          actions: [
            TextButton(
              child: const Text('Okay'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Product' : 'Add Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      onSaved: (value) => _editedProduct.title = value,
                      validator: (value) =>
                          value.isEmpty ? 'Please provide a value.' : null,
                      initialValue: _initValues['title'],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      onSaved: (value) =>
                          _editedProduct.price = double.parse(value),
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter a price.';
                        if (double.tryParse(value) == null)
                          return 'Please enter a valid number.';
                        if (double.parse(value) <= 0)
                          return 'Please enter a number greater than zero.';
                        return null;
                      },
                      initialValue: _initValues['price'],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) => _editedProduct.description = value,
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter a description.';
                        if (value.length < 10)
                          return 'Should be at least 10 characters long.';
                        return null;
                      },
                      initialValue: _initValues['description'],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(
                            top: 10,
                            right: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Input a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            controller: _imageUrlController,
                            onEditingComplete: () => setState(() {}),
                            onSaved: (value) => _editedProduct.imageUrl = value,
                            onFieldSubmitted: (_) => _saveForm(),
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Please enter an image URL.';
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https'))
                                return 'Please enter a valid URL.';
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg'))
                                return 'Please enter a valid image URL.';
                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
