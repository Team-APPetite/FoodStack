import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/menuProvider.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: Header.getAppBar(title: menuProvider.foodName),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                menuProvider.image,
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width,
              ),
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
                    SizedBox(height: 20.0),
                    Text('SGD \$${menuProvider.price}',
                        style: TextStyles.emphasis()),
                    SizedBox(height: 20.0),
                    Text(
                        'I need ${cartProvider.getItemQuantityOf(menuProvider.foodId)} of these',
                        style:
                            TextStyles.textButton()), // TODO change to number picker
                    SizedBox(height: 20.0),
                    Text('Add notes for the restaurant:',
                        style: TextStyles.heading3()), // TODO allow adding notes
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(
                          color: ThemeColors.light,
                          width: 1,
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'none',
                          style: TextStyles.body(),
                        ),
                      ),
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
