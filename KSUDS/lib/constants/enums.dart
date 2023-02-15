enum UserType {
  customer,
  carrier,
}
enum UserStatus {
  active,
  blocked,
}
enum OrderStatus {
  pending,
  accepted,
  goingToPickup,
  pickedFood,
  arrivedAtDrop,
  delivered,
  canceled,
}

class NotificationType {
  static const int sendOffer = 0,
      acceptedOffer = 1,
      goingToPickup = 2,
      pickedFood = 3,
      arrivedAtDrop = 4,
      delivered = 5,
      canceledOrder = 6,
      rating = 7;
}

class TransactionType {
  static const int add = 0, subtract = 1;
}

enum PaymentStatus {
  Not_Paid,
  Exported,
  Paid,
}
