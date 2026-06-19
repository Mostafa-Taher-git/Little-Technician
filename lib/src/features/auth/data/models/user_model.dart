class UserModel {
  int id;
  String username;
  String password;
  String avatarIcon;
  int points;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    this.avatarIcon = '🔧',
    this.points = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
        'avatarIcon': avatarIcon,
        'points': points,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['id'] as int?) ?? 0,
        username: json['username'] as String,
        password: json['password'] as String,
        avatarIcon: (json['avatarIcon'] as String?) ?? '🔧',
        points: (json['points'] as int?) ?? 0,
      );
}
