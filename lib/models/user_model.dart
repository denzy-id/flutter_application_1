class UserModel {
  final String userId;
  final String fullName;
  final String email;
  final String password;
  final String pin;
  final String profileImagePath;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.password,
    this.pin = '123456',
    this.profileImagePath = 'assets/images/developer.png',
  });

  String get timeGreeting {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }
}