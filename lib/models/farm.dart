import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'farm.g.dart';

@HiveType(typeId: 2)
class Farm extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String ownerId;
  
  @HiveField(3)
  final double latitude;
  
  @HiveField(4)
  final double longitude;
  
  @HiveField(5)
  final double area; // in hectares
  
  @HiveField(6)
  final String? description;
  
  @HiveField(7)
  final List<String> imageUrls;
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final DateTime updatedAt;

  const Farm({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.latitude,
    required this.longitude,
    required this.area,
    this.description,
    required this.imageUrls,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerId: json['ownerId'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      area: (json['area'] as num).toDouble(),
      description: json['description'] as String?,
      imageUrls: List<String>.from(json['imageUrls'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ownerId': ownerId,
      'latitude': latitude,
      'longitude': longitude,
      'area': area,
      'description': description,
      'imageUrls': imageUrls,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Farm copyWith({
    String? id,
    String? name,
    String? ownerId,
    double? latitude,
    double? longitude,
    double? area,
    String? description,
    List<String>? imageUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Farm(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      area: area ?? this.area,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        ownerId,
        latitude,
        longitude,
        area,
        description,
        imageUrls,
        createdAt,
        updatedAt,
      ];
}

