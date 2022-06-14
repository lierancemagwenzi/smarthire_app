import 'package:flutter/material.dart';
import 'package:smarthire/src/models/DeliveryMethod.dart';
import 'package:smarthire/src/repository/settings_repository.dart';


// ignore: must_be_immutable
class PickUpMethodItem extends StatefulWidget {
  DeliveryMethod deliveryMethod;
  ValueChanged<DeliveryMethod> onPressed;
Icon icon;
  PickUpMethodItem({Key key, this.deliveryMethod, this.onPressed,this.icon}) : super(key: key);

  @override
  _PickUpMethodItemState createState() => _PickUpMethodItemState();
}

class _PickUpMethodItemState extends State<PickUpMethodItem> {
  String heroTag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        this.widget.onPressed(widget.deliveryMethod);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: appcolor.value.bgColor,
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

                  ),
                  child:widget.icon,
                ),
                Container(
                  height: widget.deliveryMethod.selected ? 60 : 0,
                  width: widget.deliveryMethod.selected ? 60 : 0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Theme.of(context).accentColor.withOpacity(this.widget.deliveryMethod.selected ? 0.74 : 0),
                  ),
                  child: Icon(
                    Icons.check,
                    size: this.widget.deliveryMethod.selected ? 44 : 0,
                    color: Theme.of(context).primaryColor.withOpacity(widget.deliveryMethod.selected ? 0.9 : 0),
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.deliveryMethod.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          widget.deliveryMethod.description,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
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
