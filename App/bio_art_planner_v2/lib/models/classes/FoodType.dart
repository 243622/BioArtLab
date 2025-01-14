class FoodType{
  late int? foodTypeId;
  late String name;

  late List? animalTypes;

  FoodType({
    this.foodTypeId,
    required this.name,
    this.animalTypes
});

  Map<String, dynamic> toJson(){
    return {
      "foodTypeId": foodTypeId,
      'name': name,
      "animals": animalTypes
    };
  }

}