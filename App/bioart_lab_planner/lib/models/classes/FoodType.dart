class FoodType{
  late int? foodTypeId;
  late String name;

  FoodType({
    this.foodTypeId,
    required this.name,
});

  Map<String, dynamic> toJson(){
    return {
      "foodTypeId": foodTypeId,
      'name': name,
    };
  }

}