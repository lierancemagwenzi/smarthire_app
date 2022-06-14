import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/service.dart';
import 'package:smarthire/constants/globals.dart' as global;

import 'SingleProviderScreen.dart';

class SeeAllProvidersScreen extends StatefulWidget {
  ServiceModel serviceModel;

  SeeAllProvidersScreen({
    @required this.serviceModel,
  });
  @override
  _SeeAllProvidersScreenState createState() => _SeeAllProvidersScreenState();
}

class _SeeAllProvidersScreenState extends State<SeeAllProvidersScreen> {
  double height;
  double width;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: smarthireBlue,
        title: Text(
          widget.serviceModel.service_name,
          style: TextStyle(fontFamily: "sans"),
        ),
      ),
      body: Providers(),
    );
  }

  Widget Providers() {
    List<ProviderModel> providers = global.providers
        .where((i) =>
            i.category_id.toString() == widget.serviceModel.id.toString())
        .toList();

    return Container(
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
        children: List.generate(providers.length, (index) {
          ProviderModel providerModel = providers[index];
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

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(seconds: 1),
                  pageBuilder: (_, __, ___) => SingleProviderScreen(
                    index: index,
                    providerModel: providerModel,
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                    color: Colors.green,
                    child: AspectRatio(
                        aspectRatio: 2 / 3,
                        child: Image(
                            image: NetworkImage(global.fileserver + images[0]),
                            fit: aspect_ratios[0] < 1
                                ? BoxFit.fill
                                : BoxFit.fitHeight))),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: width,
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AutoSizeText(
                          providerModel.service_name,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontFamily: "sans"),
                        ),
                        AutoSizeText(
                          providerModel.currency + providerModel.price,
                          maxLines: 1,
                          style: TextStyle(fontFamily: "sans"),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
