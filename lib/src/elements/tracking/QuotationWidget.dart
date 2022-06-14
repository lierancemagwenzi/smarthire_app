import 'package:flutter/material.dart';
import 'package:smarthire/src/elements/CircularLoadingWidget.dart';
import 'package:smarthire/src/helpers/Helper.dart';
import 'package:smarthire/src/models/OrderModel.dart';
import 'package:smarthire/src/repository/settings_repository.dart';

class QuotationWidget extends StatefulWidget {

  OrderModel orderModel;

  QuotationWidget({Key key, this.orderModel}) : super(key: key);
  @override
  _QuotationWidgetState createState() => _QuotationWidgetState();
}

class _QuotationWidgetState extends State<QuotationWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar:widget.orderModel==null?Container(height: 0,width: 0,): widget.orderModel.quotations!=null? Container(
          height: MediaQuery.of(context).size.height*0.2,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: appcolor.value.bgColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Quotation",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Helper.getPrice(Helper.CalculateQuotationTotal(widget.orderModel.quotations), context, style: Theme.of(context).textTheme.subtitle1, zeroPlaceholder: '0')
                  ],
                ),
                SizedBox(height: 5),


                SizedBox(height: 10),
                Stack(
                  fit: StackFit.loose,
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: FlatButton(
                        onPressed: () {

                        },
                        disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        color:appcolor.value.darkcolor,
                        shape: StadiumBorder(),
                        child: Text(
                          "Total   ",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Helper.getPrice(Helper.CalculateQuotationTotal(widget.orderModel.quotations), context,

                          style: Theme.of(context).textTheme.headline4.merge(TextStyle(color:Colors.white,fontSize: 14.0)), zeroPlaceholder: 'Free'),
                    )
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ):Container(height: 0.0,),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
     Navigator.of(context).pop();

          },
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).hintColor,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Service Quotation",
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
        body: widget.orderModel==null?CircularLoadingWidget(height: 500,):Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.orderModel.quotations==null?CircularLoadingWidget(height: 500,):ListView.builder(
              itemCount: widget.orderModel.quotations.length,
              itemBuilder: (BuildContext context,int index){
                return ListTile(
                  leading: Icon(Icons.arrow_forward_ios,color: appcolor.value.darkcolor,),
                  title:Text(widget.orderModel.quotations[index].name,style: TextStyle(color: appcolor.value.darkcolor,fontSize: 18,fontWeight: FontWeight.bold)) ,

                  trailing:Helper.getPrice(widget.orderModel.quotations[index].price, context,style: TextStyle(color: appcolor.value.darkcolor,fontSize: 14)) ,


                );
              }
          ),
        )
    );
  }
}
