import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/pages/orders/LocationPicker.dart';
import 'package:smarthire/src/controllers/address_controller.dart';
import 'package:smarthire/src/models/Address.dart';
import 'package:smarthire/src/repository/settings_repository.dart';

class AddressBottomSheetWidget extends StatefulWidget {

  GlobalKey<ScaffoldState> scaffoldKey;

  AddressBottomSheetWidget({@required this.scaffoldKey});

  @override
  _AddressBottomSheetWidgetState createState() => _AddressBottomSheetWidgetState();
}

class _AddressBottomSheetWidgetState extends StateMVC<AddressBottomSheetWidget> {


  AddressController _con;

  _AddressBottomSheetWidgetState() : super(AddressController()) {
    _con = controller;
  }


  @override
  void initState() {
   _con.scaffoldKey=widget.scaffoldKey;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white
          ,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
        ],
      ),

      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top:15.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0),
            child: Container(
              child: ListView(children: [
                SizedBox(height: 20.0,),
                InkWell(

                  onTap: () async {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PlacePicker(
                            apiKey:
                            mapskey,
                            initialPosition:
                            LocationPicker.kInitialPosition,
                            useCurrentLocation: true,
                            selectInitialPosition: true,
                            //usePlaceDetailSearch: true,
                            onPlacePicked: (result) async {
                              if(result!=null){}
                              AddressModel address=    new AddressModel(address:result.formattedAddress,latitude: result.geometry.location.lat,longitude: result.geometry.location.lng,name: "Address");
                              final coordinates = new Coordinates(address.latitude, address.longitude);

                              await Geocoder.local
                                  .findAddressesFromCoordinates(coordinates)
                                  .then((value) {

                                for (int i = 0; i < value.length; i++) {
                                  print('${value[i].locality}');
                                  if (value[i].locality != null && value[i].locality.length > 1) {
                                    setState(() {
                                     address.city = value[i].locality;

                                    });
                                    break;
                                  }
                                }
                              });
                              _con.addAddress(address);
                              // selectedPlace = result;
                              // locationController.text=selectedPlace.formattedAddress;
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                          );
                        },
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Theme.of(context).focusColor),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: appcolor.value.darkcolor,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                  "Add New Address",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: appcolor.value.headerStyle,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).focusColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 25),
_con.addresses.length>0?Container(child: Center(child: Text("Swipe to delete address .Tap to select address",maxLines: 1,)),):Container(),
                ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _con.addresses.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 25);
                  },
                  itemBuilder: (context, index) {
//                return DeliveryAddressesItemWidget(
//                  address: _con.addresses.elementAt(index),
//                  onPressed: (Address _address) {
//                    _con.chooseDeliveryAddress(_address);
//                  },
//                  onLongPress: (Address _address) {
//                    DeliveryAddressDialog(
//                      context: context,
//                      address: _address,
//                      onChanged: (Address _address) {
//                        _con.updateAddress(_address);
//                      },
//                    );
//                  },
//                  onDismissed: (Address _address) {
//                    _con.removeDeliveryAddress(_address);
//                  },
//                );
                    return Dismissible(

                      key: Key(_con.addresses[index].id.toString()),
                      onDismissed: (direction) {
                       _con.deleteAddress(_con.addresses[index]);
                      },
                      child: InkWell(
                        onTap: () {
                          _con.changeAddress(_con.addresses[index]);
                          Navigator.of(widget.scaffoldKey.currentContext).pop();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Theme.of(context).focusColor),
                              child: Icon(
                                Icons.place,
                                color: Theme.of(context).primaryColor,
                                size: 22,
                              ),
                            ),
                            SizedBox(width: 15),
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          _con.addresses.elementAt(index).address,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Theme.of(context).focusColor,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],),
            ),
          ),
        )
,
        Container(
          height: 30,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).focusColor.withOpacity(0.05),
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          child: Container(
            width: 30,
            decoration: BoxDecoration(
              color: appcolor.value.darkcolor.withOpacity(0.5),

              borderRadius: BorderRadius.circular(3),
            ),
            //child: SizedBox(height: 1,),
          ),
        ),
      ],),
    );
  }
}
