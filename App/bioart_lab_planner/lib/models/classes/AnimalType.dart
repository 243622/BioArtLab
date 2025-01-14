class AnimalType{
  late int? animalTypeId;
  late String name;

  AnimalType({
    this.animalTypeId,
    required this.name
});

  Map<String, dynamic> toJson(){
    return {
      "animalTypeId" : animalTypeId,
      "name": name
    };
  }
}