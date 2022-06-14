import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/src/models/OrderModel.dart';
import 'package:smarthire/src/models/ProductOrder.dart';

import '../helpers/helper.dart';


class ProductOrderItemWidget extends StatelessWidget {
  final String heroTag;
  final ProductOrder productOrder;
  final OrderModel order;

  const ProductOrderItemWidget({Key key, this.productOrder, this.order, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        // Navigator.of(context).pushNamed('/Product', arguments: RouteArgument(id: this.productOrder.product.id));
      },
      child: productOrder.product==null?Container(height: 0,width: 0,): Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: heroTag + DateTime.now().millisecondsSinceEpoch.toString(),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: CachedNetworkImage(
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  imageUrl:Helper.getProductCover(productOrder.product),
                  placeholder: (context, url) => Image.asset(
                    'assets/loading.gif',
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          productOrder.product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),

                        Text(
                          productOrder.product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Helper.getPrice(Helper.getPriceNum(productOrder.product.price).toString(), context, style: Theme.of(context).textTheme.subtitle1),
                      Text(
                        " x " + productOrder.quantity.toString(),
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
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
