// profile_state.dart
part of 'profile_bloc.dart';

@immutable
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoadInProgress extends ProfileState {}

class ProfileLoadSuccess extends ProfileState {
  final User user;
  final bool isCurrentUser;

  const ProfileLoadSuccess({
    required this.user,
    this.isCurrentUser = false,
  });

  @override
  List<Object?> get props => [user, isCurrentUser];

  ProfileLoadSuccess copyWith({
    User? user,
    bool? isCurrentUser,
  }) {
    return ProfileLoadSuccess(
      user: user ?? this.user,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}

class ProfileLoadFailure extends ProfileState {
  final String message;

  const ProfileLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateInProgress extends ProfileState {
  final User user;

  const ProfileUpdateInProgress(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileUpdateSuccess extends ProfileState {
  final User user;

  const ProfileUpdateSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileUpdateFailure extends ProfileState {
  final String message;
  final User user;

  const ProfileUpdateFailure({
    required this.message,
    required this.user,
  });

  @override
  List<Object?> get props => [message, user];
}

class ProfilePictureUploadInProgress extends ProfileState {
  final User user;
  final double progress;

  const ProfilePictureUploadInProgress({
    required this.user,
    required this.progress,
  });

  @override
  List<Object?> get props => [user, progress];
}

class ProfilePictureUploadSuccess extends ProfileState {
  final User user;
  final String imageUrl;

  const ProfilePictureUploadSuccess({
    required this.user,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [user, imageUrl];
}

class ProfilePictureUploadFailure extends ProfileState {
  final String message;
  final User user;

  const ProfilePictureUploadFailure({
    required this.message,
    required this.user,
  });

  @override
  List<Object?> get props => [message, user];
}

class ProfilePictureDeleteInProgress extends ProfileState {
  final User user;

  const ProfilePictureDeleteInProgress(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfilePictureDeleteSuccess extends ProfileState {
  final User user;

  const ProfilePictureDeleteSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfilePictureDeleteFailure extends ProfileState {
  final String message;
  final User user;

  const ProfilePictureDeleteFailure({
    required this.message,
    required this.user,
  });

  @override
  List<Object?> get props => [message, user];
}
