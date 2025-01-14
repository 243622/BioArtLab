class FoodtypeAnimal{
  late int? foodTypesAnimalsId;
  late int foodTypeId;
  late int animalTypeId;

  FoodtypeAnimal({
    this.foodTypesAnimalsId,
    required this.foodTypeId,
    required this.animalTypeId
});
  Map<String, dynamic> toJson(){
    return {
      "foodTypesAnimalId": foodTypesAnimalsId,
      "foodtypeId": foodTypeId,
      "animalId": animalTypeId
    };
  }
}