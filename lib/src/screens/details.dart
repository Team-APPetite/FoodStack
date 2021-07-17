import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodstack/src/models/cart.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/menuProvider.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String notes = "none";

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    int itemQuantity = cartProvider.getItemQuantityOf(menuProvider.foodId);
    return Scaffold(
      appBar: Header.getAppBar(title: menuProvider.foodName),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              menuProvider.image.isNotEmpty ? Image.network(
                menuProvider.image,
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width,
                height: 350,
              ) : Container(),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      menuProvider.description,
                      style: TextStyles.heading3(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    Text('SGD \$${menuProvider.price}',
                        style: TextStyles.emphasis()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'I need   ',
                            style: TextStyles
                                .textButton()),
                        CustomNumberPicker(
                            onValue: (value) {
                              itemQuantity = value;
                            },
                            initialValue: itemQuantity,
                            maxValue: 20,
                            minValue: 1),
                        Text(
                            '   of these',
                            style: TextStyles
                                .textButton()),

                      ],
                    ),

                    SizedBox(
                      height: 10.0,
                    ),

                    Text('Add notes for the restaurant:',
                        style:
                            TextStyles.heading3()),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      cursorColor: ThemeColors.oranges,
                      maxLines: 7,
                      decoration: InputDecoration(
                        fillColor: ThemeColors.light,
                        hintText: "Notes",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      onChanged: (value) {
                        notes = value;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    AppButton(
                      buttonText: 'ADD TO CART',
                      onPressed: () {
                        cartProvider.addToCart(CartItem(
                            foodId: menuProvider.foodId,
                            foodName: menuProvider.foodName,
                            image: menuProvider.image,
                            price: menuProvider.price,
                            quantity: itemQuantity,
                            notes: notes));

                        Fluttertoast.showToast(
                          msg: 'Item has been added to cart',
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 3,
                          backgroundColor: ThemeColors.dark,
                        );

                        Navigator.pop(context);
                      },
                    )
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
