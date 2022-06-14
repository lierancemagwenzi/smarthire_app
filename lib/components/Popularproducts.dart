import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:smarthire/pages/services/Directions.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:smarthire/pages/services/ProductScreen.dart';

PopularProducts(List<ProviderModel> products, double width, double height,
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
                                        products[index].service_name,
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

DisplayImage(ProviderModel providerModel) {
  List<String> images = [];
  List<double> aspect_ratios = [];
  List<String> gallery = providerModel.product_gallery.split("#");
  List<String> ratios = providerModel.aspect_ratio.split("#");

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
      globals.fileserver + images[0],
      fit: aspect_ratios[0] > 1 ? BoxFit.fill : BoxFit.cover,
    ),
  );
}
