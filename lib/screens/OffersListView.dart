import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/helpers/Api.dart';

import 'AddOfferView.dart';
import 'OfferDetailsView.dart';

class OffersListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OffersListState();
  }
}

class _OffersListState extends State<OffersListView> {
  var _offers = [];

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offers List')),
      body: Column(children: [
        Expanded(
            child: ListView.builder(
          itemBuilder: _buildOfferItem,
          itemCount: _offers.length,
        ))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddOfferView()))
              .then((_) => _loadOffers());
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildOfferItem(BuildContext context, int index) {
    return Card(
      child: ListTile(
        //leading: Image.network(Api().getOfferImageUrl(_meals[index]['Id'])),
        title: Text(_offers[index]['title'],
            style: TextStyle(color: Colors.black54)),
        subtitle: Text(_offers[index]['price'].toString(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OfferDetailsView(offer_id: _offers[index]['id'])));
        },
      ),
    );
  }

  _loadOffers() async {
    var response = await Api().getData('/offer');
    if (response.statusCode == 200) {
      setState(() {
        _offers = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error ' + response.statusCode + ': ' + response.body),
      ));
    }
  }
}
