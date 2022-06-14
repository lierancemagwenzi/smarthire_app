import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as globals;

import 'ThirdScreen.dart';

class SecondScreen extends StatefulWidget {

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  TextEditingController priceController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  double height;
  double width;
  String uniterror = "";
  String selectedunit;

  List<String> units = [
    "litres",
    "kg",
    "gramms",
    "packet",
    "sack",
    "pocket",
    "bucket",
    "ml",
    "pair"
  ];

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "Add "+globals.productUploadModel.product_type,
          style: TextStyle(color: smarthireBlue),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: smarthireDark,
              size: 30.0,
            )),
      ),
      body:  Padding(
    padding: const EdgeInsets.symmetric(horizontal:8.0),
    child: Container(
      height: height,
      child: SingleChildScrollView(

        child: Column(children: [
        Padding(
        padding: const EdgeInsets.all(8.0),
        child:   Text(globals.productUploadModel.product_type+ " Price and Quantity",style: TextStyle(color: smarthireDark,fontSize: 20.0,fontFamily: "mainfont"),),
        ),
          unitFieldWidget(),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AutoSizeText(
                  uniterror,
                  maxLines: 1,
                  style: TextStyle(color: Colors.redAccent),
                ),
              ],
            ),
          ),

Form(
  key: _formKey,
  child:   Column(
    // shrinkWrap: true,
    // physics: ClampingScrollPhysics(),
    children: [

      Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              else if(!isNumber(value)){

                return 'Please enter a valid quantity';
              }
              return null;
            },

            decoration: new InputDecoration(
                floatingLabelBehavior:
                FloatingLabelBehavior.always,
                labelText: "Base Quantity",
                labelStyle: TextStyle(color: smarthireDark),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                filled: true,

                hintStyle: new TextStyle(
                    color: smarthireDark,
                    fontFamily: 'mainfont',
                    fontSize: 14.0),
                hintText: "base quantity",
                fillColor: smarthireWhite),
          ),
      ),
      SizedBox(
          height: 10.0,
      ),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: priceController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              else if(!isNumber(value)){

                return 'Please enter a valid quantity';
              }
              return null;
            },
            decoration: new InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: "Product Price",
                labelStyle: TextStyle(color: smarthireDark),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                filled: true,

  //                            labelText: "Price /callout fee",
                hintStyle: new TextStyle(
                    color: smarthireDark,
                    fontFamily: 'mainfont',
                    fontSize: 14.0),
                hintText: "Product Price",
                fillColor: smarthireWhite),
          ),
      ),
      SizedBox(height: height*0.2,),
      RaisedButton(
          color: smarthireBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () {
            setState(() {
              uniterror="";
            });
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              if(selectedunit==null){
                setState(() {
                  uniterror="Please select product unit";
                });
              }
              else{
                globals.productUploadModel.price=priceController.text;
                globals.productUploadModel.quantity=quantityController.text;
                globals.productUploadModel.unit=selectedunit;
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => ThirdScreen()));

              }
            }
          },
          child: Text("Next",style: TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: "mainfont"),),
      )
  ],),
),


        ],),
      ),
    ),
    ),

    );
  }
  bool isNumber(String value) {
    if (value == null) {
      return true;
    }
    final n = num.tryParse(value);
    return n != null;
  }


  Widget unitFieldWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Unit",
                  labelStyle: TextStyle(color: smarthireDark),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: smarthireDark, width: 0.0),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
//                  prefixIcon: Icon(Icons.shopping_cart, color: Colors.black),
                  fillColor: smarthireDark),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  hint: Text(
                    "Unit",
                    style: TextStyle(
                        fontFamily: "mainfont",
                        color: smarthireDark,
                        fontWeight: FontWeight.w700),
                  ),
                  value: selectedunit,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      selectedunit = newValue;
                    });
                    print(selectedunit);
                  },
                  items: units.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            fontFamily: "mainfont",
                            color: smarthireDark,
                            fontWeight: FontWeight.w700),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}
