import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';

class JobsScreen extends StatefulWidget {
  @override
  _JobsScreenState createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "No Jobs found under this account",
          style: TextStyle(
              color: smarthireBlue, fontSize: 16.0, fontFamily: "sans"),
        ),
      ),
    );
  }
}
