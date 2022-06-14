import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/controllers/TrackingController.dart';
import 'package:smarthire/src/controllers/accept_decline_controller.dart';
import 'package:smarthire/src/elements/CircularLoadingWidget.dart';
import 'package:smarthire/src/elements/ProductOrderItemWidget.dart';
import 'package:smarthire/src/helpers/Helper.dart';
import 'package:smarthire/src/models/OrderModel.dart';
import 'package:smarthire/src/repository/settings_repository.dart';

class AcceptDeclineOrderWidget extends StatefulWidget {

  OrderModel orderModel;

  AcceptDeclineOrderWidget({Key key, this.orderModel}) : super(key: key);

  @override
  _AcceptDeclineOrderWidgetState createState() => _AcceptDeclineOrderWidgetState();
}


class _AcceptDeclineOrderWidgetState extends StateMVC<AcceptDeclineOrderWidget> {

  AcceptDeclineController _con;
  _AcceptDeclineOrderWidgetState() : super(AcceptDeclineController()) {
    _con = controller;

  }
  
  @override
  void initState() {

_con.orderModel=widget.orderModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _con.scaffoldKey,
      body:  _con.orderModel == null
          ? CircularLoadingWidget(height: 400)
          : CustomScrollView(slivers: <Widget>[
        SliverAppBar(
        snap: true,
        floating: true,
        centerTitle: true,
        title: Text(
          "Order Details",
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: InkWell(
            onTap: (){

              Navigator.pop(context);

            },

            child: Icon(Icons.arrow_back_ios,color: appcolor.value.darkcolor,)),

      ),

      SliverList(
      delegate: SliverChildListDelegate([

        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Opacity(
                opacity: 1==1 ? 1 : 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 14),
                      padding: EdgeInsets.only(top: 20, bottom: 5),
                      decoration: BoxDecoration(
                        color: appcolor.value.bgColor,
                        boxShadow: [
                          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                        ],
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: Column(
                          children: <Widget>[
                            Text('OrderId: #${_con.orderModel.id}'),
                            Text(
                              DateFormat('dd-MM-yyyy | HH:mm').format(DateTime.now()),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Helper.getPrice(Helper.getTotalOrderPrice(_con.orderModel), context, style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 14)),
                            Text(
                             _con.orderModel.paymentMethod!=null?  '${_con.orderModel.paymentMethod.name??''}':"",
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                        children: <Widget>[
                         _con.orderModel.order_products.length>0? Column(
                              children: List.generate(
                               _con.orderModel.order_products.length,
                                    (indexProduct) {
                                  return ProductOrderItemWidget(
                                      heroTag: 'my_order_1', order:_con.orderModel, productOrder:_con.orderModel.order_products.elementAt(indexProduct));
                                },
                              )):Container(width: 0.0,height:0,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "Delivery Fee",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                    ),
                                    Helper.getPrice(_con.orderModel.delivery_fee, context, style: Theme.of(context).textTheme.subtitle1)
                                  ],
                                ),

                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "Total",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                    ),
                                    Helper.getPrice(Helper.getTotalOrderPrice(_con.orderModel), context, style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 14)),

                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        children: <Widget>[

                          if (_con.orderModel.orderStatus.status!="cancelled"&&_con.orderModel.orderStatus.provider_next_stage!=null)
                            FlatButton(
                              color:appcolor.value.darkcolor,
                              onPressed: () {

_con.acceptOrder(context,_con.orderModel.deliveryMethod.name.toLowerCase());
                              },
                              textColor:Colors.white ,
                              child: Wrap(
                                children: <Widget>[Text( "Accept Order", style: TextStyle(height: 1.3))],

                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                            ),
                          SizedBox(width: 20,),
                          if (_con.orderModel.orderStatus.can_cancel)
                            FlatButton(
                              color: Colors.red,
                              textColor:Colors.white ,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      title: Wrap(
                                        spacing: 10,
                                        children: <Widget>[
                                          Icon(Icons.report, color: Colors.orange),
                                          Text(
                                            "Confirmation",
                                            style: TextStyle(color: Colors.orange),
                                          ),
                                        ],
                                      ),
                                      content: Text("Are you sure you want to cancel this order"),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: new Text(
                                            "Yes",
                                            style: TextStyle(color: Theme.of(context).hintColor),
                                          ),
                                          onPressed: ()  {
                                            Navigator.of(context).pop();
                                            setState(() {

                                            });
                                            // _con.orderController.Cancelorder(_con.orderModel.id, _con.index);
                                            // Navigator.of(context).pop();

                                            setState(() {

                                            });
                                          },
                                        ),
                                        FlatButton(
                                          child: new Text(
                                            "Close",
                                            style: TextStyle(color: Colors.orange),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Wrap(
                                children: <Widget>[Text("Decline Order" + " ", style: TextStyle(height: 1.3)), Icon(Icons.clear,color: Colors.white,)],
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
        
        
        
      ]))
      ]),
    );
  }
}
