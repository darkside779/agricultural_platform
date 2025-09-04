// profile_event.dart
part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  final String userId;
  final bool isCurrentUser;

  const ProfileLoadRequested({
    required this.userId,
    this.isCurrentUser = false,
  });

  @override
  List<Object?> get props => [userId, isCurrentUser];
}

class ProfileUpdateRequested extends ProfileEvent {
  final User user;
  final Map<String, dynamic> updates;

  const ProfileUpdateRequested({
    required this.user,
    required this.updates,
  });

  @override
  List<Object?> get props => [user, updates];
}

class ProfilePictureUploadRequested extends ProfileEvent {
  final XFile imageFile;

  const ProfilePictureUploadRequested(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

class ProfilePictureUploadProgress extends ProfileEvent {
  final double progress;

  const ProfilePictureUploadProgress(this.progress);

  @override
  List<Object?> get props => [progress];
}

class ProfilePictureDeleteRequested extends ProfileEvent {
  final User user;

  const ProfilePictureDeleteRequested(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileResetRequested extends ProfileEvent {
  const ProfileResetRequested();

  @override
  List<Object?> get props => [];
}
