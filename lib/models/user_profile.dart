// ignore_for_file: overridden_fields

import 'package:hive/hive.dart';
import 'user.dart';

@HiveType(typeId: 10)
class UserProfile extends User {
  @override
  @HiveField(12) // Continue from where User left off
  final int postCount;

  @HiveField(13)
  final int followersCount;

  @HiveField(14)
  final int followingCount;

  const UserProfile({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    super.profileImageUrl,
    super.phoneNumber,
    super.location,
    required super.createdAt,
    required super.updatedAt,
    super.bio,
    super.nationalNumber,
    super.preferredLanguage,
    super.notificationPreferences,
    this.postCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        postCount,
        followersCount,
        followingCount,
      ];

  @override
UserProfile copyWith({
  String? id,
  String? email,
  String? name,
  String? bio,
  String? location,
  String? phoneNumber,
  String? nationalNumber,
  String? profileImageUrl,
  UserRole? role,
  DateTime? createdAt,
  DateTime? updatedAt,
  String? preferredLanguage,
  Map<String, bool>? notificationPreferences,
  Map<String, String>? socialLinks, // Add this to match parent class
  int? postCount, // Add this to match parent class
  int? followersCount,
  int? followingCount,
}) {
  return UserProfile(
    id: id ?? this.id,
    email: email ?? this.email,
    name: name ?? this.name,
    bio: bio ?? this.bio,
    location: location ?? this.location,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    nationalNumber: nationalNumber ?? this.nationalNumber,
    profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    notificationPreferences: notificationPreferences ?? this.notificationPreferences,
    followersCount: followersCount ?? this.followersCount,
    followingCount: followingCount ?? this.followingCount,
  );
}

  factory UserProfile.fromUser(
    User user, {
    int postCount = 0,
    int followersCount = 0,
    int followingCount = 0,
  }) {
    return UserProfile(
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      profileImageUrl: user.profileImageUrl,
      phoneNumber: user.phoneNumber,
      location: user.location,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      bio: user.bio,
      nationalNumber: user.nationalNumber,
      preferredLanguage: user.preferredLanguage,
      notificationPreferences: user.notificationPreferences,
      postCount: postCount,
      followersCount: followersCount,
      followingCount: followingCount,
    );
  }
}
