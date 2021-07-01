// import 'package:flutter/material.dart';
// import 'package:foodstack/src/screens/menu.dart';
// import 'package:foodstack/src/services/firestoreUsers.dart';
// import 'package:foodstack/src/styles/textStyles.dart';
// import 'package:foodstack/src/styles/themeColors.dart';

// // Will update UI and modularize later

// class PastOrderCard extends StatefulWidget {
//   final String restaurantId;
//   final String restaurantName;
//   final String cuisineType;
//   final double deliveryFee;
//   final double rating;
//   final String image;

//   PastOrderCard(this.restaurantId, this.restaurantName, this.cuisineType,
//       this.deliveryFee, this.rating, this.image);

//   @override
//   _PastOrderCardState createState() => _PastOrderCardState();
// }

// class _PastOrderCardState extends State<PastOrderCard> {
//   @override
//   Widget build(BuildContext context) {
//     final FirestoreUsers firestoreService = FirestoreUsers();

//     return TextButton(
//       onPressed: () {},
//       child: Container(
//         height: 130.0,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24.0),
//           border: Border.all(
//             color: ThemeColors.light,
//             width: 1,
//           ),
//           color: Colors.white,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child:
//               Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//             Expanded(
//               flex: 3,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 12.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.restaurantName,
//                       style: TextStyles.heading3(),
//                     ),
//                     Text(
//                       widget.cuisineType,
//                       style: TextStyles.details(),
//                     ),
//                     SizedBox(
//                       height: 10.0,
//                     ),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.star_rounded,
//                           color: ThemeColors.yellows,
//                         ),
//                         Icon(
//                           Icons.star_rounded,
//                           color: ThemeColors.yellows,
//                         ),
//                         Icon(
//                           Icons.star_rounded,
//                           color: ThemeColors.yellows,
//                         ),
//                         Icon(
//                           Icons.star_half_rounded,
//                           color: ThemeColors.yellows,
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//                 flex: 1,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     IconButton(
//                       icon: _favourites
//                           ? Icon(
//                               Icons.favorite,
//                               color: Colors.red,
//                             )
//                           : Icon(
//                               Icons.favorite_border,
//                               color: ThemeColors.light,
//                             ),
//                       iconSize: 30.0,
//                       onPressed: () {
//                         setState(() {
//                           _favourites = !_favourites;
//                           _favourites
//                               ? firestoreService
//                                   .addToFavourites(widget.restaurantId)
//                               : firestoreService
//                                   .removeFromFavourites(widget.restaurantId);
//                         });
//                       },
//                     ),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.delivery_dining,
//                           color: ThemeColors.teals,
//                           size: 20,
//                         ),
//                         Text(
//                           '\$${widget.deliveryFee}',
//                           style: TextStyles.details(),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )),
//           ]),
//         ),
//       ),
//     );
//   }
// }
