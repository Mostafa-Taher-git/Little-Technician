class UserModel {
  int id;
  String username;
  String password;
  String avatarIcon;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    this.avatarIcon = '🔧',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
        'avatarIcon': avatarIcon,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['id'] as int?) ?? 0,
        username: json['username'] as String,
        password: json['password'] as String,
        avatarIcon: (json['avatarIcon'] as String?) ?? '🔧',
      );
}
