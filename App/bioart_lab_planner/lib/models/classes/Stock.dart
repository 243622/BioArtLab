class Stock{
  late int? stockId;
  late int? quantity;
  late int? foodTypeId;
  late int? minimumQuantity;
  late String? foodTypeInString;

  Stock({
    this.stockId,
    required this.quantity,
    required this.foodTypeId,
    required this.minimumQuantity,
    this.foodTypeInString
});

  Map<String, dynamic> toJson(){
    return {
      "stockid": stockId,
      "quantity": quantity,
      "foodtype": foodTypeId,
      'minimumquantity': minimumQuantity
    };
  }
}