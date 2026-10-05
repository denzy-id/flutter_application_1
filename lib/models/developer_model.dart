class DeveloperModel {
  final String developerName;
  final String role;
  final String appVersion;
  final List<String> techStack;
  final String bio;
  final String email;
  final String avatarPath;

  DeveloperModel({
    required this.developerName,
    required this.role,
    required this.appVersion,
    required this.techStack,
    required this.bio,
    required this.email,
    this.avatarPath = 'assets/images/developer.png',
  });
}