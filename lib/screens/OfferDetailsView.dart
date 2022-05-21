import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/helpers/Api.dart';

class OfferDetailsView extends StatefulWidget {
  @override
  _OfferDetailsState createState() => _OfferDetailsState();
  final int offer_id;
  OfferDetailsView({this.offer_id});
}

class _OfferDetailsState extends State<OfferDetailsView> {
  @override
  void initState() {
    super.initState();
    _loadOfferDetails();
  }

  var offer;

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
            child: offer != null ? _buildFormFields() : Text('Loading...'),
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
            Text(offer['title']),
            Text(offer['price'].toString()),
            Text(offer['category']['name']),
            _buildGridView(),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
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

  Widget _buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(offer['images'].length, (index) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: <Widget>[
              Image.network(
                Api().getOfferImageUrl(offer['images'][index]['id']),
                width: 300,
                height: 300,
              ),
            ],
          ),
        );
      }),
    );
  }

  _loadOfferDetails() async {
    var response = await Api().getData('/offer/' + widget.offer_id.toString());
    if (response.statusCode == 200) {
      setState(() {
        offer = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Error ' + response.statusCode.toString() + ': ' + response.body),
      ));
    }
  }
}
