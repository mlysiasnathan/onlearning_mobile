class User {
  int? userId;
  String? userName;
  String? image;
  String? token;

  User({this.userId, this.userName, this.image, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user']['user_id'],
      userName: json['user']['user_name'],
      image: json['user']['path'],
      token: json['token'],
    );
  }
}
