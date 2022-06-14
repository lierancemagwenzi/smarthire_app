import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/src/elements/tracking/QuotationWidget.dart';
import 'package:smarthire/src/helpers/Helper.dart';
import 'package:smarthire/src/models/OrderModel.dart';
import 'package:smarthire/src/repository/settings_repository.dart';

Widget ReceivedOrderTracker(OrderModel orderModel,BuildContext context){

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [

        ListTile(
    title: Text(

        "Status",
        style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),
            subtitle: Text(Helper.StatusBreak(orderModel.orderStatus.customer_stage),style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,))),

        Container(


          child: ListTile(title: Text("Status Explanation ",
        style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),

          subtitle: Text(orderModel.orderStatus.provider_explanation??'',style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),
          ),
        ),
  orderModel.order_type!=null? ListTile(
  title: Text("Order Type",style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),

  subtitle:Text(orderModel.order_type,style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),

  ):Container(height: 0.0,),
        orderModel.sellerAccount!=null? ListTile(
trailing: orderModel.orderStatus.canchat?Icon(Icons.chat_bubble_outline):null,
          title: Text("Client",style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),

          subtitle:Text(orderModel.user.name,style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),

        ):Container(height: 0.0,),

        orderModel.available_times!=null? ListTile(
          title: Text("Provider available times",
              style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),

          subtitle:               Text(orderModel.available_times,style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),

        ):Container(height: 0.0,),


        orderModel.picked_time!=null? ListTile(

          title: Text(" Client Picked Time",style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),

          subtitle:Text(orderModel.picked_time??'unknown',style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),
        ):Container(height: 0.0,),


        orderModel.deliveryMethod!=null? ListTile(
          title: Text("Delivery Method",style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),

          subtitle:               Text(orderModel.deliveryMethod.name,style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),

        ):Container(height: 0.0,),


        orderModel.delivery_date!=null? ListTile(
          title: Text("Delivery date",style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),

          subtitle:               Text(orderModel.delivery_date,style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),

        ):Container(height: 0.0,),

       orderModel.requested_date!=null? ListTile(
title: Text("Service requested Date"),
         subtitle:               Text("Client requested date for service delivery is "+(orderModel.requested_date??' '),style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),


        ):Container(height: 0.0,),


        orderModel.delivery_fee!=null? ListTile(

          title: Text("Delivery Fee",style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),

          subtitle:               Text(orderModel.delivery_fee,style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),
        ):Container(height: 0.0,),


        orderModel.callout_fee!=null? ListTile(

          title: Text("Call Out Fee",style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),

          subtitle:               Text(orderModel.callout_fee,style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),
        ):Container(height: 0.0,)
,



        orderModel.calloutfeemethod!=null? ListTile(
          title: Text("CallOut Fee Payment",style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),

          subtitle:               Text(orderModel.calloutfeemethod.status,style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),

        ):Container(height: 0.0,),
        orderModel.calloutfeemethod!=null&&orderModel.calloutfeemethod.paymentMethod!=null? ListTile(
          title: Text("CallOut  Payment Method",style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),

          subtitle:Text(orderModel.calloutfeemethod.paymentMethod.name,style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),

        ):Container(height: 0.0,),

        orderModel.quotations!=null&&orderModel.quotations.length>0? ListTile(

          title: Text("View Quotation",style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),
trailing: Icon(Icons.arrow_forward_ios),
          subtitle:               Text('click to view quotation',style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),

          onTap: (){
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => QuotationWidget(orderModel: orderModel,)));

},

        ):Container(height: 0.0,),


        orderModel.payment!=null? ListTile(
          title: Text("Payment",style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),

          subtitle:Text(orderModel.payment.status,style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),

        ):Container(height: 0.0,),

        orderModel.payment!=null&&orderModel.payment.paymentMethod!=null? ListTile(
          title: Text("Payment Method",style: appcolor.value.headerStyle.copyWith(color: appcolor.value.darkcolor,)),

          subtitle:               Text(orderModel.payment.paymentMethod.name,style: appcolor.value.bodyStyle.copyWith(color: appcolor.value.darkcolor,)),

        ):Container(height: 0.0,),
      ],
    ),
  );
}