import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class ShowUserScreen extends StatefulWidget {
  @override
  _ShowUserScreenState createState() => _ShowUserScreenState();
}

class _ShowUserScreenState extends State<ShowUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: smarthireBlue,
        title: Text(
          "Customer",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
