import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/sizeroute.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'package:intl/intl.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/review.dart';
import 'package:smarthire/pages/auth/SingleImage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/pages/orders/LocationPicker.dart';
import 'package:smarthire/pages/orders/SingleOrderScreen.dart';
import 'package:smarthire/pages/orders/provider/AddPrices.dart';

class CreateQuotationScreen extends StatefulWidget {
  OrderModel orderModel;
  CreateQuotationScreen({@required this.orderModel});

  @override
  _CreateQuotationScreenState createState() => _CreateQuotationScreenState();
}

class _CreateQuotationScreenState extends State<CreateQuotationScreen> {
  double height;
  double width;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController;
  static List<String> friendsList = [null];
  void handleClick(String value) {
    switch (value) {
      case 'See Order':
        Navigator.push(
            context,
            SlideRightRoute(
                page: SingleOrderScreen(
              orderModel: widget.orderModel,
            )));
        break;
        break;
      case 'Add Custom Product':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: smarthireDark,
        title: Text("Create Quotation"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: PopupMenuButton<String>(
              color: Colors.white,
              onSelected: handleClick,
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 30.0,
              ),
              itemBuilder: (BuildContext context) {
                return {
                  'See Order',
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      choice,
                      style: TextStyle(color: smarthireDark),
                    ),
                  );
                }).toList();
              },
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              Text(
                'Quotation Items',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'sans',
                    color: Colors.black),
              ),
              ..._getFriends(),
              FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Navigator.push(
                        context,
                        SizeRoute(
                          page: AddPrices(
                            orderModel: widget.orderModel,
                            elements: friendsList,
                          ),
                        ));
                    print(friendsList[0]);
                  } else {
                    print(_formKey.currentState.validate());
                  }
                },
                child: Text(
                  'Proceed',
                  style: TextStyle(color: Colors.white),
                ),
                color: smarthireDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          friendsList.insert(0, null);
        } else
          friendsList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  List<Widget> _getFriends() {
    List<Widget> friendsTextFields = [];
    for (int i = 0; i < friendsList.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: FriendTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == friendsList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFields;
  }
}

class FriendTextFields extends StatefulWidget {
  final int index;
  FriendTextFields(this.index);
  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text =
          _CreateQuotationScreenState.friendsList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameController,
      style: TextStyle(color: Colors.black),
      onChanged: (v) =>
          _CreateQuotationScreenState.friendsList[widget.index] = v,
      decoration: InputDecoration(
        hintText: 'Enter an item',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: smarthireDark, width: 0.0),
        ),
        border: new OutlineInputBorder(
          borderSide: BorderSide(color: smarthireDark),
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        hintStyle: new TextStyle(
            color: Colors.black, fontFamily: 'sans', fontSize: 14.0),
      ),
      validator: (v) {
        if (v.trim().isEmpty) return 'Please Type something';

        return null;
      },
    );
  }
}
