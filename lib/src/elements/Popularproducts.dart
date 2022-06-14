import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:smarthire/pages/services/Directions.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:smarthire/src/controllers/homepage_controller.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/pages/ProductScreen.dart';
import 'package:smarthire/src/helpers/Helper.dart' as helper;
import 'package:smarthire/src/repository/settings_repository.dart';

PopularProducts1(List<Product> products, double width, double height,
    BuildContext context) {
  double widthh = width * 0.7;
  return Container(
    height: height,
    child: ListView.builder(
        itemCount: products.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext ctxt, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ProductScreen(
                              providerModel: products[index],
                            )));
              },
              child: Container(
                height: height,
                width: products.length == 1 ? width : widthh,
                child: Column(
                  children: <Widget>[
                    Container(
                        height: height * 0.6,
                        width: width,
                        color: Color(0xffc7d2d7),
                        child: DisplayImage(products[index])),
                    Expanded(
                      child: Container(
                        color:globals.darkmode?Colors.black: Colors.white,
                        width: width,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: widthh * 0.6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      AutoSizeText(
                                        products[index].name,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: smarthireDark,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "mainfont",
                                            fontSize: 18.0),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      AutoSizeText(
                                        products[index].provider_name,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color:
                                                smarthireDark.withOpacity(0.5),
                                            fontFamily: "mainfont",
                                            fontSize: 16.0),
                                      ),
                                      SizedBox(
                                        height: 1.0,
                                      ),
                                      AutoSizeText(
                                        products[index].location,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color:
                                                smarthireDark.withOpacity(0.5),
                                            fontFamily: "mainfont",
                                            fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    onTap: () {
//                                      Navigator.push(
//                                          context,
//                                          CupertinoPageRoute(
//                                              builder: (context) =>
//                                                  DirectionsScreen()));
                                    },
                                    child: Container(
                                      color: Colors.blue,
                                      width: width * 0.2,
                                      height: height * 0.15,
                                      child: Icon(
                                        Icons.directions,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
  );
}


PopularProducts(List<Product> products, double width, double height,
    BuildContext context,HomePageController _con) {
  return Container(
    height: height*0.4,
    child: ListView.builder(
        itemCount: products.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext ctxt, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ProductScreen(
                              providerModel: products[index],
                            )));
              },
              child: Container(
                height: height*0.45
                ,
                width: width*0.6,
                decoration: BoxDecoration(
                  // color: Color(0xffc7d2d7),
                    border: Border.all(
                      color: Colors.blueGrey.withOpacity(0.3),

                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                        height: height * 0.18,
                        width: width,

                        child: DisplayImage(products[index])),


                    Flexible(

                      child: Container(
                        color:appcolor.value.bgColor,
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              ListTile(
                                title:        Text(products[index].name,style: appcolor.value.bodyStyle.copyWith(fontWeight: FontWeight.normal,fontSize: 18.0,),),
                                subtitle:     Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(products[index].location,style: appcolor.value.bodyStyle.copyWith(fontWeight: FontWeight.normal,fontSize: 12.0,),),
SizedBox(height: 20.0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(currency+products[index].price,style: appcolor.value.bodyStyle.copyWith(fontWeight: FontWeight.bold,fontSize: 14.0),),

                                            products[index].discount!=null?helper.Helper.getDiscount(products[index].discount)>0?Text(currency+products[index].discount,style: appcolor.value.bodyStyle.copyWith(decoration: TextDecoration.lineThrough,decorationThickness:2.0,fontWeight: FontWeight.bold,fontSize: 14.0),):Text(""):Text(""),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right:8.0),
                                          child: InkWell(

                                            onTap: (){
                                              if( products[index].liked==null){
                                                _con.LikeProduct(products[index]);

                                              }

                                              else{
                                                _con.DisLikeProduct(products[index]);

                                              }

                                            },

                                            child: Icon(
                                              products[index].liked==null?  Icons.favorite_border:Icons.favorite,
                                              color: smarthirePurple,
                                              size: 30.0,
                                            ),
                                          ),
                                        )

                                      ],
                                    )
                                  ],
                                ),

                              ),





                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
  );
}




DisplayImage(Product product) {
  List<String> images = [];
  List<double> aspect_ratios = [];
  List<String> gallery = product.product_gallery.split("#");
  List<String> ratios = product.aspect_ratio.split("#");

  gallery.removeLast();
  ratios.removeLast();
  for (int i = 0; i < gallery.length; i++) {
    images.add(gallery[i]);
  }
  for (int i = 0; i < ratios.length; i++) {
    aspect_ratios.add(double.parse(ratios[i]));
  }
  return AspectRatio(
    aspectRatio: aspect_ratios[0],
    child: Image.network(
      '${GlobalConfiguration().getValue('base_url')}${images[0]}',
      fit: aspect_ratios[0] > 1 ? BoxFit.contain : BoxFit.contain,
    ),
  );
}
