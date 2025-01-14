class Message{
  late int? messageId;
  late String message;

  Message({
    this.messageId,
    required this.message
});

  Map<String, dynamic> toJson(){
    return {"messageId": messageId,
      "message": message
    };
  }
}