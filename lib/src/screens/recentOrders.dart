import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodstack/src/models/cart.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';

class RecentOrdersScreen extends StatefulWidget {
  @override
  _RecentOrdersScreenState createState() => _RecentOrdersScreenState();
}

class _RecentOrdersScreenState extends State<RecentOrdersScreen> {
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final uid = FirebaseAuth.instance.currentUser.uid.toString();

    if (!loading) {
      return Scaffold(
          appBar: Header.getAppBar(title: 'Recent Orders'),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<List<Cart>>(
                stream: cartProvider.getPastOrdersList(uid),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: Text('You have no past orders!'));
                  } else {
                    return Scrollbar(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Text("It works!");
                            }));
                  }
                }),
          ));
    } else {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }
}
