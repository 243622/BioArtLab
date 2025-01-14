
class User{
  late int? userId;
  late String? username;
  late String? password;
  late int? function;

  User({
    this.userId,
    required this.username,
    required this.password,
    this.function
  });

  Map<String, dynamic> toJson(){
    return{
      "userId": userId,
      "username": username,
      "password": password,
      "function": function
    };
  }

}