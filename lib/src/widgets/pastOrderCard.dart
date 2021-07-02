import 'package:flutter/material.dart';
import 'package:foodstack/src/models/cart.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PastOrderCard extends StatefulWidget {
  String cartId;
  List<CartItem> cartItems = [];
  String restaurantId;
  String restaurantName = 'Restaurant';
  double deliveryFee = 0.0;
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

  Future<void> _getRestaurantInfo() async {
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    await restaurantProvider.getRestaurant(widget.restaurantId);
    setState(() {
       widget.restaurantName = restaurantProvider.restaurantName;
       widget.deliveryFee = restaurantProvider.deliveryFee;
    });
  }

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
          List cartItems = widget.cartItems;
          for (int i = 0; i < cartItems.length; i++) {
            CartItem currCartItem = cartItems[i];
            cartProvider.addToCart(CartItem(
                foodId: currCartItem.foodId,
                foodName: currCartItem.foodName,
                image: currCartItem.image,
                price: currCartItem.price,
                notes: 'none'));
            // (these cartItems will already be there in the cart)
          }

          Navigator.pushNamed(context, '/menu', arguments: {
            'restaurantId': widget.restaurantId,
            'restaurantName': widget.restaurantName,
            'deliveryFee': widget.deliveryFee,
          });
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
                  Text('${widget.restaurantName}',
                      style: TextStyles.heading2()),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Subtotal: \$ ${widget.subtotal}',
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
                      Text(
                        '\$${widget.deliveryFee}',
                        style: TextStyles.details(),
                      ),
                    ],
                  ),

                  // (no total)
                ],
              ),
            )));
  }
}
