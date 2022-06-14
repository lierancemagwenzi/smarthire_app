import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/src/helpers/Helper.dart';
import 'package:smarthire/src/models/ProductOrder.dart';
import 'package:smarthire/src/repository/settings_repository.dart';


// ignore: must_be_immutable
class CartItemWidget extends StatefulWidget {
  String heroTag;
  ProductOrder cart;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;
  CartItemWidget({Key key, this.cart, this.heroTag, this.increment, this.decrement, this.onDismissed}) : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
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

                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5,
                            children: <Widget>[
                              Helper.getPrice(widget.cart.product.price, context, style: Theme.of(context).textTheme.headline4, zeroPlaceholder: 'Free'),
                              widget.cart.product!=null
                                  ? Helper.getDeliveryPrice(widget.cart.product.discount, context,
                                  style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(decoration: TextDecoration.lineThrough)))
                                  : SizedBox(height: 0),
                            ],
                          ),
                          //Helper.getPrice(widget.cart.getProductPrice(), context, style: Theme.of(context).textTheme.headline4)
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.increment();
                            });
                          },
                          iconSize: 30,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          icon: Icon(Icons.add_circle_outline),
                          color: Theme.of(context).hintColor,
                        ),
                        Text(widget.cart.quantity.toString(), style: Theme.of(context).textTheme.subtitle1),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.decrement();
                            });
                          },
                          iconSize: 30,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          icon: Icon(Icons.remove_circle_outline),
                          color: Theme.of(context).hintColor,
                        ),
                      ],
                    ),
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
