import 'package:flutter/material.dart';
import 'package:smarthire/src/repository/settings_repository.dart';


// ignore: must_be_immutable
class NotDeliverableAddressesItemWidget extends StatelessWidget {
  NotDeliverableAddressesItemWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: appcolor.value.darkcolor.withOpacity(0.3),

          boxShadow: [
            BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.orange,
                  ),
                  child: Icon(
                    Icons.report,
                    color: Theme.of(context).primaryColor,
                    size: 38,
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                   "Delivery Outside the delivery Range of this market",
                      style: Theme.of(context).textTheme.caption.copyWith(inherit: true,color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                    "The product does not support delivery",
                      style: Theme.of(context).textTheme.caption.copyWith(inherit: true,color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                     "One or more products in your cart is not eligible for delivery",
                      style: Theme.of(context).textTheme.caption.copyWith(inherit: true,color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
