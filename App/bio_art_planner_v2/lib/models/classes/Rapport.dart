class Rapport{
  late int? rapportId;
  late String title;
  late String? description;
  late String? photos;
  late String? exceptionalities;
  DateTime? date;
  late int userId;
  late String? userName;

  Rapport({
   this.rapportId,
   required this.title,
    this.description,
   this.photos,
   this.exceptionalities,
    this.date,
    required this.userId,
    this.userName
});
  Map<String, dynamic> toJson(){
    return {
      "rapportid": rapportId,
      "title": title,
      'description': description,
      'photos': photos,
      'exceptionalities': exceptionalities,
      'date': date,
      "userId": userId,
      "username": userName
    };

  }
}