class Animal{
  late int? animalId;
  late String? name;
  late int? animalTypeId;
  late DateTime? birthDate;
  late String? lifeStage;
  late String? sicknesses;
  late String? description;
  late String? animalTypeInString;
  Animal({
    this.animalId,
    this.name,
    required this.animalTypeId,
    required this.birthDate,
    this.sicknesses,
    this.description,
    this.animalTypeInString
});

  Map<String, dynamic> toJson(){
    return {
      "animalId": animalId,
      "name": name,
      "animaltype": animalTypeId,
      'birthdate': birthDate,
      'sicknesses': sicknesses,
      'description': description
  };
}
}