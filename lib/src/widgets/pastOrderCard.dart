import 'package:flutter/material.dart';
import 'package:foodstack/src/models/cart.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PastOrderCard extends StatefulWidget {
  String cartId;
  List<CartItem> cartItems = [];
  String restaurantId;
  String restaurantName;
  double deliveryFee;
  double subtotal;

  PastOrderCard(String id, List list, String rstId, String rstName,
      double price, double fee) {
    cartId = id;
    list.forEach((item) => cartItems.add(CartItem.fromJson(item)));
    restaurantId = rstId;
    restaurantName = rstName;
    subtotal = price;
    deliveryFee = fee;
  }

  @override
  _PastOrderCardState createState() => _PastOrderCardState();
}

class _PastOrderCardState extends State<PastOrderCard> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    Widget _cartItem(String id, String name, String price, int quantity) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(name, style: TextStyles.heading3()),
                  SizedBox(height: 5.0),
                  Text(price, style: TextStyles.details()),
                ],
              ),
            ),
            Text('x $quantity', style: TextStyles.heading3()),
          ],
        ),
      );
    }

    return TextButton(
        onPressed: () {
          List cartItems = widget.cartItems;
          for (int i = 0; i < cartItems.length; i++) {
            CartItem currCartItem = cartItems[i];
            cartProvider.addToCart(CartItem(
                foodId: currCartItem.foodId,
                foodName: currCartItem.foodName,
                image: currCartItem.image,
                price: currCartItem.price,
                quantity: currCartItem.quantity,
                notes: 'none'));
          }

          Navigator.pushNamed(context, '/menu', arguments: {
            'restaurantId': widget.restaurantId,
            'restaurantName': widget.restaurantName,
            'deliveryFee': widget.deliveryFee,
            'image': ''
          });
        },
        child: Container(
            margin: const EdgeInsets.only(
                bottom: 3.0, right: 2.0, top: 1.0, left: 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: ThemeColors.light,
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.light,
                  offset: Offset(0.0, 2.0), //(x,y)
                  blurRadius: 3.0,
                ),
              ],
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(widget.restaurantName, style: TextStyles.heading3()),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.cartItems.length,
                      itemBuilder: (context, index) {
                        return _cartItem(
                          widget.cartItems[index].foodId,
                          widget.cartItems[index].foodName,
                          '\$' + widget.cartItems[index].price.toString(),
                          widget.cartItems[index].quantity,
                        );
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Subtotal \$${widget.subtotal}',
                              style: TextStyles.details(),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.delivery_dining,
                        color: ThemeColors.teals,
                        size: 20,
                      ),
                      Text('\$${widget.deliveryFee}',
                          style: TextStyles.details()),
                    ],
                  ),
                ],
              ),
            )));
  }
}
