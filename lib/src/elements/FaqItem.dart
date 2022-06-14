import 'package:flutter/material.dart';
import 'package:smarthire/src/helpers/Helper.dart';
import 'package:smarthire/src/models/FaqModel.dart';
import 'package:smarthire/src/repository/settings_repository.dart';


class FaqItemWidget extends StatelessWidget {
  final FaqModel faq;
  FaqItemWidget({Key key, this.faq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Theme.of(context).focusColor.withOpacity(0.15),
          offset: Offset(0, 5),
          blurRadius: 15,
        )
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration:
            BoxDecoration(color: appcolor.value.darkcolor, borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            child: Text(
              Helper.skipHtml(this.faq.question),
              style:TextStyle(color: Colors.white),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: appcolor.value.bgColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5))),
            child: Text(
              Helper.skipHtml(this.faq.response),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}
