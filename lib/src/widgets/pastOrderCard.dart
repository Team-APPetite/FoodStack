import 'package:flutter/material.dart';
import 'package:foodstack/src/models/cart.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';

// ignore: must_be_immutable
class PastOrderCard extends StatefulWidget {
  String cartId;
  List<CartItem> cartItems = [];
  String restaurantId;
  double subtotal;

  PastOrderCard(String id, List list, String rstId, double price) {
    cartId = id;
    list.forEach((item) => cartItems.add(CartItem.fromJson(item)));
    restaurantId = rstId;
    subtotal = price;
  }

  @override
  _PastOrderCardState createState() => _PastOrderCardState();
}

class _PastOrderCardState extends State<PastOrderCard> {
  @override
  void initState() {
    super.initState();
    _getRestaurantInfo();
  }

  _getRestaurantInfo() async {

    // restaurant provider

  }

  @override
  Widget build(BuildContext context) {
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
                  Text(price, style: TextStyles.emphasis()),
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
          // cartProvider.getCart(widget.cartId);
          // navigate to menu of restaurant
          // (these cartItems will already be there in the cart)
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: ThemeColors.light,
                width: 1,
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [

                  // restaurant name

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

                  // subtotal

                  // restaurant delivery fee (full) 
                  // (with the delivery bike icon)

                  // (no total)

                ],
              ),
            )));
  }
}
