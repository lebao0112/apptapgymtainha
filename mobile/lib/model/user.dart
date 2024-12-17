class User {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final double? height;
  final double? weight;
  final List<dynamic>? workoutHistory;
  final DateTime? dateOfBirth;
  final String? avatarUrl;
  final String? gender;
  final String? role;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.height,
    this.weight,
    this.workoutHistory,
    this.dateOfBirth,
    this.avatarUrl,
    this.gender,
    this.role,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    double? height,
    double? weight,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }

  // Chuyển JSON thành đối tượng User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['Name'],
      email: json['Email'],
      password: json['Password'],
      height: (json['Height'] as num?)?.toDouble(),
      weight: (json['Weight'] as num?)?.toDouble(),
      workoutHistory: json['WorkoutHistory'] ?? [],
      dateOfBirth: json['DateOfBirth'] != null
          ? DateTime.parse(json['DateOfBirth'])
          : null,
      avatarUrl: json['AvatarUrl'],
      gender: json['Gender'],
      role: json['Role'],
    );
  }

  // Chuyển đối tượng User thành JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Name': name,
      'Email': email,
      'Password': password,
      'Height': height,
      'Weight': weight,
      'WorkoutHistory': workoutHistory,
      'DateOfBirth': dateOfBirth?.toIso8601String(),
      'AvatarUrl': avatarUrl,
      'Gender': gender,
      'Role': role,
    };
  }
}
