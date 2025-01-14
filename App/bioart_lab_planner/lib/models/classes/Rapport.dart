class Rapport{
  late int? rapportId;
  late int taskId;
  late String title;
  late String description;
  late String? photos;
  late String? exceptionalities;
  DateTime date = DateTime.now();

  Rapport({
   this.rapportId,
   required this.taskId,
   required this.title,
   required this.description,
   this.photos,
   this.exceptionalities,
    required this.date
});
  Map<String, dynamic> toJson(){
    return {
      "rapportid": rapportId,
      "taskId": taskId,
      "title": title,
      'description': description,
      'photos': photos,
      'exceptionalities': exceptionalities,
      'date': date
    };

  }
}