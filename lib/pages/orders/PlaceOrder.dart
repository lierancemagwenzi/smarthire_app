import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/review.dart';
import 'package:smarthire/pages/auth/SingleImage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:smarthire/pages/orders/LocationPicker.dart';
import 'package:smarthire/pages/orders/SingleOrderScreen.dart';


bool agree=false;
class PlaceOrderScreen extends StatefulWidget {

  PlaceOrderScreen({@required this.providerModel});
  ProviderModel providerModel;


  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  PickResult selectedPlace;
  double height;
  double width;
bool loading=false;
  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(

      bottomNavigationBar: BottomAppBar(child:    RaisedButton.icon(
        padding: EdgeInsets.symmetric(
            vertical: height * .015, horizontal: width * .08),
        color: smarthireBlue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        onPressed: global.id==0?null:() {
          Validate();


        },
        icon: Icon(
          Icons.card_giftcard,
          color: Colors.white,
        ),
        label: Text(
          "order "+ widget.providerModel.product_type,
          style: TextStyle(color: smarthireWhite, fontFamily: "sans"),
        ),
      ),),
      appBar: AppBar(
        backgroundColor: smarthireBlue,
        title: Text(
          widget.providerModel.service_name,
          style: TextStyle(fontFamily: "sans"),
        ),
      ),
body: Stack(
  children: [
        Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(widget.providerModel.product_type+" name",style: TextStyle(fontWeight: FontWeight.bold),),
        Text(widget.providerModel.service_name),

        Text("Price",style: TextStyle(fontWeight: FontWeight.bold),),
        Text(widget.providerModel.currency+widget.providerModel.price),

        Text("Provider",style: TextStyle(fontWeight: FontWeight.bold),),
        ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(widget.providerModel.profile_pic),),
            title: Text(widget.providerModel.provider_name)),
        widget.providerModel.product_type=="service"?ServiceLocation():ProductLocation()
    ],),loading?Center(child: CircularProgressIndicator(),):Text("")
  ],
),
    );
  }


  ServiceLocation(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


    InkWell(

            onTap: (){

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return PlacePicker(
          apiKey: "AIzaSyAifHKAGENQ6hWJD2nb5RgKKQCtPkeFs00",
          initialPosition: LocationPicker.kInitialPosition,
          useCurrentLocation: true,
          selectInitialPosition: true,
          //usePlaceDetailSearch: true,
          onPlacePicked: (result) {
            selectedPlace = result;
            Navigator.of(context).pop();
            setState(() {});
          },
        );
      },
    ),
  );

},
            child: Text("Service Location"+(selectedPlace==null?"[Add]":"[Change]"),style: TextStyle(fontWeight: FontWeight.bold),)),




        selectedPlace != null? Text(selectedPlace.formattedAddress ?? ""):Container(),

      ],);

  }


  ProductLocation(){
   return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.providerModel.service_name),
        Theme(
          data: ThemeData(unselectedWidgetColor: Color(0xff005f8e)),
          child: CheckboxListTile(
            title: AutoSizeText("Delivery?",maxLines:1,style: TextStyle(color: Colors.black),),
            value:agree,
            checkColor: Color(0xff0B1A2D),
            activeColor: Colors.white,

            onChanged: (bool val) {
              setState(() {
                agree = val;
              });
              if(agree){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PlacePicker(
                        apiKey: "AIzaSyAifHKAGENQ6hWJD2nb5RgKKQCtPkeFs00",
                        initialPosition: LocationPicker.kInitialPosition,
                        useCurrentLocation: true,
                        selectInitialPosition: true,
                        //usePlaceDetailSearch: true,
                        onPlacePicked: (result) {
                          selectedPlace = result;
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                      );
                    },
                  ),
                );
              }
              else{}

            },
          ),
        ),

        selectedPlace!=null&& agree?Text("Delivery Adrress",style: TextStyle(fontWeight: FontWeight.bold),):Text(""),
        selectedPlace != null  && agree? Text(selectedPlace.formattedAddress ?? ""):Container(),

      ],);
  }



   Validate(){
print("validate");

    if(widget.providerModel.product_type=="product"){
      if(selectedPlace==null&&agree==false){
        SendOrder();
      }

      else{
if(agree){

  print("please select ");

}

else{



}

      }


    }

    else{


      if(selectedPlace!=null){
        print("good service adreess");
        SendOrder();
      }

      else{

print("null adreess");

      }

    }
  }


String getAddress(){

    if(widget.providerModel.product_type=="product"){
      if(selectedPlace==null&&agree==false){
        return "";
      }

      else{

        return selectedPlace.formattedAddress;

      }


    }

    else{
      return selectedPlace.formattedAddress ;

    }
}


getCoord(){
  if(widget.providerModel.product_type=="product"){
    if(selectedPlace==null&&agree==false){
      return [0,0];
    }
    else{
      return selectedPlace.geometry.location.lat.toString()+"#"+selectedPlace.geometry.location.lng.toString();
    }

  }
  else{
   return selectedPlace.geometry.location.lat.toString()+"#"+selectedPlace.geometry.location.lng.toString();
  }

}




  Future<void> SendOrder() async {
setState(() {
  loading=true;
});
    print("sending order");
    try {
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
        // Make a GET request
            () => http.post(global.url + '/api/saveorder',
            body: jsonEncode({
              "customer_id": global.id,
              "delivery":agree?1:0,
              "product_id":widget.providerModel.service_id,
              "customer_address":getAddress(),
              "coord": getCoord(),
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      setState(() {
      });
      if (response.statusCode == 201) {
                OrderModel  orderModel=OrderModel.fromJson(jsonDecode(response.body));
                orderModel.user_profile=global.fileserver+orderModel.user_profile;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => SingleOrderScreen(orderModel: orderModel)));
        print("inserted");

        setState(() {

        });

      } else {

        print("failed");
        if (response.statusCode == 401) {}
      }


      setState(() {
        loading=false;
      });
    } on TimeoutException catch (e) {
      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      setState(() {
    loading=false;
      });
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      print('kkkkkk General Error: $e');
    }
  }
}
