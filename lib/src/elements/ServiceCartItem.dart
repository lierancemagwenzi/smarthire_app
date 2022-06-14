import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/src/helpers/Helper.dart';
import 'package:smarthire/src/models/ProductOrder.dart';
import 'package:smarthire/src/repository/settings_repository.dart';


// ignore: must_be_immutable
class ServiceCartItemWidget extends StatefulWidget {
  String heroTag;
  ProductOrder cart;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;
  ServiceCartItemWidget({Key key, this.cart, this.heroTag, this.increment, this.decrement, this.onDismissed}) : super(key: key);

  @override
  _ServiceCartItemWidgetState createState() => _ServiceCartItemWidgetState();
}

class _ServiceCartItemWidgetState extends State<ServiceCartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.cart.product.toString()),
      onDismissed: (direction) {
        setState(() {
          widget.onDismissed();
        });
      },
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        onTap: () {

        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
            color: appcolor.value.bgColor,
            boxShadow: [
              BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: CachedNetworkImage(
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                  imageUrl:Helper.getProductCover(widget.cart.product),
                  placeholder: (context, url) => Image.asset(
                    'assets/loading.gif',
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                  errorWidget: (context, url, error) => Container(height: 0.0,width: 0.0,),
                ),
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
                            widget.cart.product.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            widget.cart.product.provider_name.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
                          ),


                          AutoSizeText(
                            widget.cart.product.location,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal,fontSize: 14.0),
                          ),
                          SizedBox(height: 10.0,),
                          AutoSizeText(
                            "MON-Sat"+    " 0900-2000",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold,fontSize: 14.0),
                          ),
                          // Wrap(
                          //   crossAxisAlignment: WrapCrossAlignment.center,
                          //   spacing: 5,
                          //   children: <Widget>[
                          //     Helper.getPrice(widget.cart.product.price, context, style: Theme.of(context).textTheme.headline4, zeroPlaceholder: 'Free'),
                          //     widget.cart.product!=null
                          //         ? Helper.getDeliveryPrice(widget.cart.product.discount, context,
                          //         style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(decoration: TextDecoration.lineThrough)))
                          //         : SizedBox(height: 0),
                          //   ],
                          // ),
                          //Helper.getPrice(widget.cart.getProductPrice(), context, style: Theme.of(context).textTheme.headline4)
                        ],
                      ),
                    ),
                    SizedBox(width: 8),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
