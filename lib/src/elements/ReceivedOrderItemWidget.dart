import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:smarthire/src/controllers/order_controller.dart';
import 'package:smarthire/src/elements/ProductOrderItemWidget.dart';
import 'package:smarthire/src/helpers/Helper.dart';
import 'package:smarthire/src/models/OrderModel.dart';
import 'package:smarthire/src/pages/seller/Tracking.dart';
import 'package:smarthire/src/repository/settings_repository.dart';


class ReceivedOrderItemWidget extends StatefulWidget {
  final bool expanded;
  final OrderModel order;
  int index;
  OrderController orderController;
  final ValueChanged<void> onCanceled;

  ReceivedOrderItemWidget({Key key, this.expanded, this.order, this.onCanceled,this.orderController,this.index}) : super(key: key);

  @override
  _ReceivedOrderItemWidgetState createState() => _ReceivedOrderItemWidgetState();
}

class _ReceivedOrderItemWidgetState extends State<ReceivedOrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    DateFormat format =
    DateFormat("yyyy-MM-ddTHH:mm:ssZ");

    var formated =
    format.parse(widget.order.order_date);
    var date =
    DateFormat.yMMMMEEEEd().format(formated);


    return Stack(
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
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                  ],
                ),
                child: Theme(
                  data: theme,
                  child: ExpansionTile(
                    initiallyExpanded: widget.expanded,
                    title: Column(
                      children: <Widget>[
                        Text('OrderID: #${widget.order.id}'),
                        Text(
                          date??'',
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

                        Text(
                          widget.order.paymentMethod!=null?widget.order.paymentMethod.name:"",
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                    children: <Widget>[
                    widget.order.order_products.length>0?  Column(
                          children: List.generate(
                        widget.order.order_products.length,
                        (indexProduct) {
                          return ProductOrderItemWidget(
                              heroTag: 'mywidget.orders', order: widget.order, productOrder: widget.order.order_products.elementAt(indexProduct));
                        },
                      )):Container(height: 0,width: 0,),
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
                                Helper.getPrice(widget.order.delivery_fee, context, style: Theme.of(context).textTheme.subtitle1)
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
                                Helper.getPrice(Helper.getTotalOrderPrice(widget.order), context, style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 14))
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => TrackingWidget(orderModel: widget.order,orderController: widget.orderController,index: widget.index,context: context,)));
                      },
                      textColor: Theme.of(context).hintColor,
                      child: Wrap(
                        children: <Widget>[Text("View")],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    if (widget.order.orderStatus.can_cancel)
                      FlatButton(
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
                                content: Text("Are you sure you want to Cancel this order"),
                                contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                                actions: <Widget>[
                                  FlatButton(
                                    child: new Text(
                                      "Yes",
                                      style: TextStyle(color: Theme.of(context).hintColor),
                                    ),
                                    onPressed: () {
                                      widget.onCanceled(widget.order);
                                      Navigator.of(context).pop();
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
                        textColor: Theme.of(context).hintColor,
                        child: Wrap(
                          children: <Widget>[Text("Cancel" + " ")],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(start: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 28,
          width: 140,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)), color:widget.order.orderStatus.status=="cancelled"?Colors.red: appcolor.value.darkcolor),
          alignment: AlignmentDirectional.center,
          child: Text(
          '${widget.order.orderStatus.status}',
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: Theme.of(context).textTheme.caption.merge(TextStyle(height: 1, color:Colors.white)),
          ),
        ),
      ],
    );
  }
}
