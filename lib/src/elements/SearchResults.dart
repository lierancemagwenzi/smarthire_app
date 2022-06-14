import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/controllers/search_controller.dart';
import 'package:smarthire/src/elements/CircularLoadingWidget.dart';
import 'package:smarthire/src/models/SearchModel.dart';
import 'package:smarthire/src/pages/Category.dart';
import 'package:smarthire/src/pages/ProductScreen.dart';
import 'package:smarthire/src/repository/settings_repository.dart';

class SearchResults extends StatefulWidget {
  final String heroTag;

  SearchResults({Key key, this.heroTag}) : super(key: key);
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends StateMVC<SearchResults> {

  SearchController _con;

  _SearchResultsState() : super(SearchController()) {

    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              trailing: IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).hintColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                "Search",
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                "Ordered by Nearby",
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onSubmitted: (text) async {
                _con.SearchProducts(new SearchModel(search: text));
                // await _con.refreshSearch(text);
                // _con.saveSearch(text);
              },
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: "Search for market and products",
                hintStyle: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 14)),
                prefixIcon: Icon(Icons.search, color: Theme.of(context).accentColor),
                border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.3))),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
              ),
            ),
          ),
       _con.searching
              ? CircularLoadingWidget(height: 288)
              : _con.products.length<1&&_con.categories.length<1&&_con.services.length<1?Container():Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ListTile(
                    dense: true,
        trailing: IconButton(
    icon: Icon(_con.productresults?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down),
    color: Theme.of(context).hintColor,
    onPressed: () {
      setState(() { _con.productresults=!_con.productresults;});

    },
    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    title: Text(
"Product Results"  ,                    style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
               !_con.productresults?Container():ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _con.products.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: Column(
                        children: [

                          InkWell(

                            onTap:(){

                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ProductScreen(
                                        providerModel: _con.products[index],
                                      )));
                            },
                            child: ListTile(

                              title:        Text(_con.products[index].name,style: appcolor.value.bodyStyle.copyWith(fontWeight: FontWeight.normal,fontSize: 18.0,),),
                              subtitle:     Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_con.products[index].location,style: appcolor.value.bodyStyle.copyWith(fontWeight: FontWeight.normal,fontSize: 12.0,),),


                                  SizedBox(height: 5.0,),
                                  Text(_con.products[index].city,style: appcolor.value.bodyStyle.copyWith(fontWeight: FontWeight.bold,fontSize: 14.0),),

                                  SizedBox(height: 20.0,),
                                  Text(currency+_con.products[index].price,style: appcolor.value.bodyStyle.copyWith(fontWeight: FontWeight.bold,fontSize: 14.0),),
                                ],
                              ),

                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ListTile(
                    dense: true,
                    trailing: IconButton(
                      icon: Icon(_con.servicesresults?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down),
                      color: Theme.of(context).hintColor,
                      onPressed: () {
                        setState(() { _con.servicesresults=!_con.servicesresults;});

                      },
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    title: Text(
                      "Service Results"  , style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                !_con.servicesresults?Container():ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _con.services.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: Column(
                        children: [

                          InkWell(

                            onTap:(){

                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ProductScreen(
                                        providerModel: _con.services[index],
                                      )));
                            },
                            child: ListTile(

                              title:        Text(_con.services[index].name,style: appcolor.value.bodyStyle.copyWith(fontWeight: FontWeight.normal,fontSize: 18.0,),),
                              subtitle:     Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_con.services[index].location,style: appcolor.value.bodyStyle.copyWith(fontWeight: FontWeight.normal,fontSize: 12.0,),),


                                  SizedBox(height: 5.0,),
                                  Text(_con.services[index].city,style: appcolor.value.bodyStyle.copyWith(fontWeight: FontWeight.bold,fontSize: 14.0),),

                                  SizedBox(height: 20.0,),
                                  Text(currency+_con.services[index].price,style: appcolor.value.bodyStyle.copyWith(fontWeight: FontWeight.bold,fontSize: 14.0),),
                                ],
                              ),

                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ListTile(
                    dense: true,
                    trailing: IconButton(
                      icon: Icon(_con.categoryresults?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down),
                      color: Theme.of(context).hintColor,
                      onPressed: () {
                        setState(() { _con.categoryresults=!_con.categoryresults;});

                      },
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    title: Text(
                      "Category Results"  , style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                !_con.categoryresults?Container():  ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _con.categories.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        onTap: (){
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => CategoriesScreen(
                                    serviceModel: _con.categories[index],
                                  )));
                        },
                        trailing: Icon(Icons.category),
                        leading: AspectRatio(
                            aspectRatio:6/6,child: CircleAvatar(backgroundImage: NetworkImage(_con.categories[index].banner),)),
                        title:Text(_con.categories[index].service_name,style: appcolor.value.headerStyle,)
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
