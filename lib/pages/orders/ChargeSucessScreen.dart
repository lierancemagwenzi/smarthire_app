import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChargeSuccessScreen extends StatefulWidget {

  @override
  _ChargeSuccessScreenState createState() => _ChargeSuccessScreenState();
}

class _ChargeSuccessScreenState extends State<ChargeSuccessScreen> {


  @override
  void initState() {

    SchedulerBinding.instance.addPostFrameCallback((_) {
        CoolAlert.show(
          barrierDismissible: false,
          context: context,
          showCancelBtn: false,

          onConfirmBtnTap: (){
            Navigator.pop(context);

          },
          type: CoolAlertType.success,
          text: "Delivery Fee submited",
        );

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(


    );
  }
}
