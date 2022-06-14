import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/pages/Category.dart';
import 'package:smarthire/src/repository/settings_repository.dart';

CategoriesWidget(double height,List<ServiceModel> categories){

  return Container(
    height: height*0.2,
    child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context,int index){
          return InkWell(

            onTap: (){

              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => CategoriesScreen(
                        serviceModel: categories[index],
                      )));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                Flexible(

                  child: Container(
                    width: 60.0,
                    height: height*0.1,
                    decoration: BoxDecoration(

                      image: DecorationImage(image: NetworkImage(categories[index].banner),fit: BoxFit.contain)
                    ),

                  ),
                ),Text(categories[index].service_name,style: appcolor.value.headerStyle,overflow: TextOverflow.ellipsis,maxLines: 1,)
              ],),
            ),
          );
        }
    ),
  );
}