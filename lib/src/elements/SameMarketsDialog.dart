

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/src/controllers/product_controller.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/ProductOrder.dart';
import 'package:smarthire/src/models/Provider.dart';
import 'package:smarthire/src/repository/cart_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart';

SameMarketsDialog(List<Provider> providers,BuildContext context, VoidCallback onChanged,Provider provider,Product product,int quantity,ProductController _con){
  return AwesomeDialog(
    context: context,
    useRootNavigator: false,
    headerAnimationLoop: false,
    dialogType: DialogType.NO_HEADER,
    title: 'Provider Conflict',
    body:  Container(
      color: appcolor.value.bgColor,
      height: 200,
      child: Column(
        children: [
          Text("Your cart has conflicting suppliers.Please select one"),
          Flexible(
            child: ListView.builder(
                itemCount: providers.length,
                itemBuilder: (BuildContext context,int index){
                  return Card(
                    color: appcolor.value.darkcolor.withOpacity(0.4),
                    child: ListTile(
                      onTap: (){
                        if(onChanged!=null){
                       if(providers[index].id==provider.id){
                         cart.value.clear();
                         _con.addToCart(product);
                         // cart.value.add(new ProductOrder(product: product,quantity: quantity));
                       }
                       Navigator.pop(context);
                          onChanged();
                        }
                      },
                        title: Text(providers[index].name,
                          style: TextStyle(
                              color: Colors.white,fontSize: 15),),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    ),
    desc:
    'Different Providers Dialog',
    // btnOkOnPress: () {
    // },
    // btnCancelOnPress: (){
    //   Navigator.pop(context);
    // },
    // btnCancelIcon: Icons.cancel,
    // btnOkIcon: Icons.check_circle,
  )..show();
}