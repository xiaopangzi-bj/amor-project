class User {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final String? displayName;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.displayName,
  });

  factory User.fromGoogleSignIn(Map<String, dynamic> data) {
    return User(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? data['displayName'] ?? '',
      photoUrl: data['photoUrl'],
      displayName: data['displayName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'displayName': displayName,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'],
      displayName: json['displayName'],
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? displayName,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.photoUrl == photoUrl &&
        other.displayName == displayName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        photoUrl.hashCode ^
        displayName.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, photoUrl: $photoUrl, displayName: $displayName)';
  }
}
