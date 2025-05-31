class UserProfile {
  final int id;
  final String name;
  final String email;
  final String role;
  final String avatarUrl;
  final List<String> badges;
  final int points;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarUrl,
    required this.badges,
    required this.points,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      avatarUrl: 'https://api.dicebear.com/7.x/initials/svg?seed=${json['name']}',
      badges: ['Leadership', 'Problem Solving', 'Top Performer'],
      points: 120,
    );
  }
}