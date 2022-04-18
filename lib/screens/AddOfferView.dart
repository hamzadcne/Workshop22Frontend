import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/helpers/Api.dart';

class AddOfferView extends StatefulWidget {
  @override
  _AddOfferState createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOfferView> {
  var title;
  var category_id = 1;
  var user_id = 1;
  var price;

  // File _image;
  //final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add new Meal'),
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
            //OutlinedButton(onPressed: getImage, child: _buildImage()),
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
  // Widget _buildImage() {
  //   if (_image == null) {
  //     return Padding(
  //       padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
  //       child: Icon(
  //         Icons.add,
  //         color: Colors.grey,
  //       ),
  //     );
  //   } else {
  //     return Image.file(File(_image.path));
  //   }
  // }

  // Future getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  void _submit() async {
    // setState(() {
    //   _isLoading = true;
    // });
    var data = new Map<String, String>();
    data['title'] = title;
    data['price'] = price;
    data['user_id'] = user_id.toString();
    data['category_id'] = category_id.toString();
    // data['image'] = _image.path;

    //var response = await Api().postDataWithImage(data, '/offers', _image.path);
    var response = await Api().postData(data, '/offers');

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
