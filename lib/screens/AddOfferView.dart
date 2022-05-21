import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/helpers/Api.dart';
import 'package:image_picker/image_picker.dart';

class AddOfferView extends StatefulWidget {
  @override
  _AddOfferState createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOfferView> {
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  ImagePicker _picker = ImagePicker();
  var user_id = 1;
  var title;
  var price;
  String category_id = "2";
  var categories = [];
  List<XFile> images = [];
  //   {'id': 1, 'name': 'category 1'},
  //   {'id': 2, 'name': 'category 2'}
  // ];

  File _image;
  //final picker = imagepic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add new Offer'),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: _buildFormFields(),
          )
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 80.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                title = value;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
              onChanged: (value) {
                price = value;
              },
            ),
            DropdownButton(
              hint: Text('Select Category'),
              items: categories.map((item) {
                return new DropdownMenuItem(
                  child: Text(item['name']),
                  value: item['id'].toString(),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  category_id = value;
                });
              },
              value: category_id,
            ),
            //OutlinedButton(onPressed: getImage, child: _buildImage()),
            ElevatedButton(
              onPressed: _pickImages,
              child: Text(
                'Add Images',
              ),
            ),
            _buildGridView(),
            SizedBox(
              height: 20.0,
            ),
            _buildSubmitButton(),
            SizedBox(
              height: 10.0,
            ),
            //_buildRegisterText(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        _submit();
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
      ),
      child: Text(
        'Submit',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Widget _buildRegisterText() {
  // return Text(
  //   'REGISTER',
  //   textAlign: TextAlign.center,
  //   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
  // );
  // }
  Widget _buildImage() {
    if (_image == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
        child: Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Image.file(File(_image.path));
    }
  }

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        File image = File(images[index].path);
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: <Widget>[
              Image.file(
                image,
                width: 300,
                height: 300,
              ),
              Positioned(
                right: 5,
                top: 5,
                child: InkWell(
                  child: Icon(
                    Icons.remove_circle,
                    size: 30,
                    color: Colors.red,
                  ),
                  onTap: () {
                    setState(() {
                      images.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  _pickImages() async {
    List<XFile> res = await _picker.pickMultiImage();
    setState(() {
      images.addAll(res);
    });
  }

  _loadCategories() async {
    var response = await Api().getData('/category');
    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Error ' + response.statusCode.toString() + ': ' + response.body),
      ));
    }
  }

  void _submit() async {
    // setState(() {
    //   _isLoading = true;
    // });
    var data = new Map<String, String>();
    data['title'] = title;
    data['price'] = price;
    //data['user_id'] = user_id.toString();
    data['category_id'] = category_id.toString();
    //data['image'] = _image.path;

    var response = await Api().postDataWithImages(data, '/offer', images);
    //var response = await Api().postData(data, '/offer');

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      _showMsg('Error ${response.statusCode}');
    }
  }

  _showMsg(msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    ));
  }
}
