import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:smarthire/pages/orders/LocationPicker.dart';
import 'package:smarthire/pages/productadd/FourthScreen.dart';

class ThirdScreen extends StatefulWidget {

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final _formKey = GlobalKey<FormState>();
  double height;
  double width;

  String locationerror = '';
  String cityerror = "";

  PickResult selectedPlace;
  String selectedcity;
  TextEditingController locationController = TextEditingController();


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
body: SingleChildScrollView(

  child:   Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child:   Text(globals.productUploadModel.product_type+ " Location",style: TextStyle(color: smarthireDark,fontSize: 20.0,fontFamily: "mainfont"),),
      ),
      cityFieldWidget(),
      Container(
        child: Text(
          cityerror,
          style: TextStyle(color: Colors.redAccent),
        ),
      ),
      Form(
        key: _formKey,
        child: Column(children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: locationController,
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PlacePicker(
                        apiKey:
                        "AIzaSyAifHKAGENQ6hWJD2nb5RgKKQCtPkeFs00",
                        initialPosition:
                        LocationPicker.kInitialPosition,
                        useCurrentLocation: true,
                        selectInitialPosition: true,
                        //usePlaceDetailSearch: true,
                        onPlacePicked: (result) {
                          selectedPlace = result;
                          locationController.text=selectedPlace.formattedAddress;
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                      );
                    },
                  ),
                );
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'addrress is required';
                }
                return null;
              },
              decoration: new InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Addrress",
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
                  hintText:  "Address",
                  fillColor: smarthireWhite),
            ),
          ),


          SizedBox(height: height*0.2,),
          RaisedButton(
            color: smarthireBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              setState(() {
                cityerror="";
              });
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                if(selectedcity!=null){
                  globals.productUploadModel.city=selectedcity;
                  globals.productUploadModel. location= selectedPlace.formattedAddress;
                  globals.productUploadModel. coord= selectedPlace.geometry.location.lat.toString() +
              "#" +
              selectedPlace.geometry.location.lng.toString();

                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => FourthScreen()));
                }
                else{
                  setState(() {
                    cityerror="City is required";
                  });
                }
              }
            },
            child: Text("Next",style: TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: "mainfont"),),
          )
        ],),
      ),
    ],
  ),
),

    );
  }

  Widget cityFieldWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "City",
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
                    "City",
                    style: TextStyle(
                        fontFamily: "mainfont",
                        color: smarthireDark,
                        fontWeight: FontWeight.w700),
                  ),
                  value: selectedcity,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      selectedcity = newValue;
                    });
                    print(selectedcity);
                  },
                  items: globals.cities.map((String value) {
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
