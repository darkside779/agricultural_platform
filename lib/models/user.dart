import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
enum UserRole {
  @HiveField(0)
  guest,

  @HiveField(1)
  farmer,

  @HiveField(2)
  merchant,

  @HiveField(3)
  company,

  @HiveField(4)
  expert,

  @HiveField(5)
  admin,

  @HiveField(6)
  researcher,

  @HiveField(7)
  consultant,

  @HiveField(8)
  cooperativeManager,

  @HiveField(9)
  user,
}

@HiveType(typeId: 0)
class User extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final UserRole role;

  @HiveField(4)
  final String? profileImageUrl;

  @HiveField(5)
  final String? phoneNumber;

  @HiveField(6)
  final String? location;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;

  @HiveField(9)
  final String? bio;

  @HiveField(10)
  final String? nationalNumber;

  @HiveField(11)
  final String preferredLanguage;

  @HiveField(12)
  final int postCount;

  @HiveField(13)
  final Map<String, String>? socialLinks;

  @HiveField(14)
  final Map<String, bool> notificationPreferences;

  // Default notification preferences
  static const Map<String, bool> defaultNotificationPreferences = {
    'email': true,
    'push': true,
    'sms': false,
  };

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.profileImageUrl,
    this.phoneNumber,
    this.location,
    required this.createdAt,
    required this.updatedAt,
    this.bio,
    this.nationalNumber,
    this.preferredLanguage = 'en',
    this.postCount = 0,
    this.socialLinks,
    Map<String, bool>? notificationPreferences,
  }) : notificationPreferences =
            notificationPreferences ?? defaultNotificationPreferences;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.guest,
      ),
      profileImageUrl: json['profileImageUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      location: json['location'] as String?,
      bio: json['bio'] as String?,
      nationalNumber: json['nationalNumber'] as String?,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      postCount: json['postCount'] as int? ?? 0,
      socialLinks: json['socialLinks'] != null
          ? Map<String, String>.from(json['socialLinks'] as Map)
          : null,
      notificationPreferences: json['notificationPreferences'] != null
          ? Map<String, bool>.from(json['notificationPreferences'] as Map)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
  // Add these methods to the User class in user.dart
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'bio': bio,
      'nationalNumber': nationalNumber,
      'preferredLanguage': preferredLanguage,
      'postCount': postCount,
      'socialLinks': socialLinks,
      'notificationPreferences': notificationPreferences,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${map['role']}',
        orElse: () => UserRole.guest,
      ),
      profileImageUrl: map['profileImageUrl'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      location: map['location'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      bio: map['bio'] as String?,
      nationalNumber: map['nationalNumber'] as String?,
      preferredLanguage: map['preferredLanguage'] as String? ?? 'en',
      postCount: (map['postCount'] as int?) ?? 0,
      socialLinks: (map['socialLinks'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as String),
      ),
      notificationPreferences:
          (map['notificationPreferences'] as Map<String, dynamic>?)?.map(
                (key, value) => MapEntry(key, value as bool),
              ) ??
              User.defaultNotificationPreferences,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'location': location,
      'bio': bio,
      'nationalNumber': nationalNumber,
      'preferredLanguage': preferredLanguage,
      'postCount': postCount,
      'socialLinks': socialLinks,
      'notificationPreferences': notificationPreferences,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? profileImageUrl,
    String? phoneNumber,
    String? location,
    String? bio,
    String? nationalNumber,
    String? preferredLanguage,
    int? postCount,
    Map<String, String>? socialLinks,
    Map<String, bool>? notificationPreferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      nationalNumber: nationalNumber ?? this.nationalNumber,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      postCount: postCount ?? this.postCount,
      socialLinks: socialLinks ?? this.socialLinks,
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        role,
        profileImageUrl,
        phoneNumber,
        location,
        bio,
        nationalNumber,
        preferredLanguage,
        postCount,
        socialLinks,
        notificationPreferences,
        createdAt,
        updatedAt,
      ];
}
