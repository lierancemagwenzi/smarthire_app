import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/pages/orders/OrderScreen.dart';

class AllOrdersScreen extends StatefulWidget {

  @override
  _AllOrdersScreenState createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xfffafafa),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: smarthireDark,
            size: 30.0,
          ),
        ),
        title: Text(
          "Account Orders",
          style: TextStyle(
            color: smarthireBlue,
            fontFamily: "mainfont",
          ),
        ),

      ),
      body: OrderScreen(),
    );
  }
}
