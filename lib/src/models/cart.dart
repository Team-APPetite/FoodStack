class CartItem {
  final String foodId;
  final int quantity;
  final String notes;

  CartItem(this.foodId, this.quantity, this.notes);

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      json['foodId'],
      json['quantity'],
      json['notes'],
    );
  }

  Map<String, dynamic> toMap() =>
      {"foodId": this.foodId, "quantity": this.quantity, "notes": this.notes};
}

class Cart {
  String cartId;
  String userId;
  List<dynamic> cartItems = [];

  Cart(this.cartId, this.userId, this.cartItems);

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(json['cartId'], json['userId'], json['cartItems']);
  }

  Map<String, dynamic> toMap() => {
        "cartId": this.cartId,
        "userId": this.userId,
        "cartItems": this.cartItems
      };
}

// void SaveNestedData() {
//   Exercise exercise = Exercise("Tricep Extension", "Triceps");
//   Firestore.instance.collection("exercises").document("OWXsZjJRy3jjWmaM3Rup").setData(exercise.toMap());
// }
