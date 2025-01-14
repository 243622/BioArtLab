class Message{
  late int? messageId;
  late String title;
  late String description;

  Message({
    this.messageId,
    required this.title,
    required this.description
});

  Map<String, dynamic> toJson(){
    return {
      "messageId": messageId,
      "title": title,
      "description": description
    };
  }
}