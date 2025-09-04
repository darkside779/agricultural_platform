import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'crop.g.dart';

@HiveType(typeId: 3)
class Crop extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String farmId;
  
  @HiveField(3)
  final CropType type;
  
  @HiveField(4)
  final String variety;
  
  @HiveField(5)
  final DateTime plantingDate;
  
  @HiveField(6)
  final DateTime? expectedHarvestDate;
  
  @HiveField(7)
  final DateTime? actualHarvestDate;
  
  @HiveField(8)
  final double area; // in hectares
  
  @HiveField(9)
  final CropStatus status;
  
  @HiveField(10)
  final List<String> imageUrls;
  
  @HiveField(11)
  final String? notes;
  
  @HiveField(12)
  final DateTime createdAt;
  
  @HiveField(13)
  final DateTime updatedAt;

  const Crop({
    required this.id,
    required this.name,
    required this.farmId,
    required this.type,
    required this.variety,
    required this.plantingDate,
    this.expectedHarvestDate,
    this.actualHarvestDate,
    required this.area,
    required this.status,
    required this.imageUrls,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'] as String,
      name: json['name'] as String,
      farmId: json['farmId'] as String,
      type: CropType.values.firstWhere(
        (e) => e.toString() == 'CropType.${json['type']}',
        orElse: () => CropType.other,
      ),
      variety: json['variety'] as String,
      plantingDate: DateTime.parse(json['plantingDate'] as String),
      expectedHarvestDate: json['expectedHarvestDate'] != null
          ? DateTime.parse(json['expectedHarvestDate'] as String)
          : null,
      actualHarvestDate: json['actualHarvestDate'] != null
          ? DateTime.parse(json['actualHarvestDate'] as String)
          : null,
      area: (json['area'] as num).toDouble(),
      status: CropStatus.values.firstWhere(
        (e) => e.toString() == 'CropStatus.${json['status']}',
        orElse: () => CropStatus.planted,
      ),
      imageUrls: List<String>.from(json['imageUrls'] as List),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'farmId': farmId,
      'type': type.toString().split('.').last,
      'variety': variety,
      'plantingDate': plantingDate.toIso8601String(),
      'expectedHarvestDate': expectedHarvestDate?.toIso8601String(),
      'actualHarvestDate': actualHarvestDate?.toIso8601String(),
      'area': area,
      'status': status.toString().split('.').last,
      'imageUrls': imageUrls,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Crop copyWith({
    String? id,
    String? name,
    String? farmId,
    CropType? type,
    String? variety,
    DateTime? plantingDate,
    DateTime? expectedHarvestDate,
    DateTime? actualHarvestDate,
    double? area,
    CropStatus? status,
    List<String>? imageUrls,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Crop(
      id: id ?? this.id,
      name: name ?? this.name,
      farmId: farmId ?? this.farmId,
      type: type ?? this.type,
      variety: variety ?? this.variety,
      plantingDate: plantingDate ?? this.plantingDate,
      expectedHarvestDate: expectedHarvestDate ?? this.expectedHarvestDate,
      actualHarvestDate: actualHarvestDate ?? this.actualHarvestDate,
      area: area ?? this.area,
      status: status ?? this.status,
      imageUrls: imageUrls ?? this.imageUrls,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        farmId,
        type,
        variety,
        plantingDate,
        expectedHarvestDate,
        actualHarvestDate,
        area,
        status,
        imageUrls,
        notes,
        createdAt,
        updatedAt,
      ];
}

@HiveType(typeId: 4)
enum CropType {
  @HiveField(0)
  cereal,
  
  @HiveField(1)
  vegetable,
  
  @HiveField(2)
  fruit,
  
  @HiveField(3)
  legume,
  
  @HiveField(4)
  root,
  
  @HiveField(5)
  herb,
  
  @HiveField(6)
  other,
}

@HiveType(typeId: 5)
enum CropStatus {
  @HiveField(0)
  planted,
  
  @HiveField(1)
  growing,
  
  @HiveField(2)
  flowering,
  
  @HiveField(3)
  fruiting,
  
  @HiveField(4)
  harvested,
  
  @HiveField(5)
  failed,
}

