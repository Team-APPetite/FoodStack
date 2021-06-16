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
  String restaurantId;
  List<dynamic> cartItems = [];

  Cart(this.cartId, this.userId, this.restaurantId, this.cartItems);

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(json['cartId'], json['userId'], json['restaurantId'],
        json['cartItems']);
  }

  Map<String, dynamic> toMap() => {
        "cartId": this.cartId,
        "userId": this.userId,
        "restaurantId": this.restaurantId,
        "cartItems": this.cartItems
      };
}
