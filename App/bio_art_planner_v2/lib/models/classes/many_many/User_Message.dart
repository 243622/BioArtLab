class UserMessage{
  late int? usersMessagesId;
  late int userId;
  late int messageId;

  UserMessage({
    this.usersMessagesId,
    required this.userId,
    required this.messageId
});
  Map<String, dynamic> toJson(){
    return {
      "userMessageId": usersMessagesId,
      "userId": userId,
      "messageId": messageId
    };
  }
}