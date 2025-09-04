// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      email: fields[1] as String,
      name: fields[2] as String,
      role: fields[3] as UserRole,
      profileImageUrl: fields[4] as String?,
      phoneNumber: fields[5] as String?,
      location: fields[6] as String?,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
      bio: fields[9] as String?,
      nationalNumber: fields[10] as String?,
      preferredLanguage: fields[11] as String,
      postCount: fields[12] as int,
      notificationPreferences: (fields[13] as Map?)?.cast<String, bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.profileImageUrl)
      ..writeByte(5)
      ..write(obj.phoneNumber)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.bio)
      ..writeByte(10)
      ..write(obj.nationalNumber)
      ..writeByte(11)
      ..write(obj.preferredLanguage)
      ..writeByte(12)
      ..write(obj.postCount)
      ..writeByte(13)
      ..write(obj.notificationPreferences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserRoleAdapter extends TypeAdapter<UserRole> {
  @override
  final int typeId = 1;

  @override
  UserRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserRole.guest;
      case 1:
        return UserRole.farmer;
      case 2:
        return UserRole.merchant;
      case 3:
        return UserRole.company;
      case 4:
        return UserRole.expert;
      case 5:
        return UserRole.admin;
      case 6:
        return UserRole.researcher;
      case 7:
        return UserRole.consultant;
      case 8:
        return UserRole.cooperativeManager;
      default:
        return UserRole.guest;
    }
  }

  @override
  void write(BinaryWriter writer, UserRole obj) {
    switch (obj) {
      case UserRole.guest:
        writer.writeByte(0);
        break;
      case UserRole.farmer:
        writer.writeByte(1);
        break;
      case UserRole.merchant:
        writer.writeByte(2);
        break;
      case UserRole.company:
        writer.writeByte(3);
        break;
      case UserRole.expert:
        writer.writeByte(4);
        break;
      case UserRole.admin:
        writer.writeByte(5);
        break;
      case UserRole.researcher:
        writer.writeByte(6);
        break;
      case UserRole.consultant:
        writer.writeByte(7);
        break;
      case UserRole.cooperativeManager:
        writer.writeByte(8);
        break;
      case UserRole.user:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
