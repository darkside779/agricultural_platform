// profile_bloc.dart
// ignore_for_file: unused_import, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/user.dart';
import '../../../repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  final String _currentUserId;
  StreamSubscription? _profileSubscription;

  ProfileBloc({
    required ProfileRepository profileRepository,
    required String currentUserId,
  })  : _profileRepository = profileRepository,
        _currentUserId = currentUserId,
        super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfilePictureUploadRequested>(_onProfilePictureUploadRequested);
    on<ProfilePictureDeleteRequested>(_onProfilePictureDeleteRequested);
    on<ProfileResetRequested>(_onProfileResetRequested);
  }

  String get currentUserId => _currentUserId;

  User? get currentUser {
    final state = this.state;
    if (state is ProfileLoadSuccess) {
      return state.user;
    }
    return null;
  }

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoadInProgress());
      
      // Get the profile data
      final user = await _profileRepository.getUserProfile(event.userId);
      
      // Set up a stream subscription for real-time updates
      _profileSubscription?.cancel();
      _profileSubscription = _profileRepository.streamUserProfile(event.userId).listen((user) {
        add(ProfileLoadRequested(
          userId: event.userId,
          isCurrentUser: event.isCurrentUser,
        ));
            });
      
      emit(ProfileLoadSuccess(
        user: user,
        isCurrentUser: event.isCurrentUser,
      ));
    } catch (e) {
      emit(ProfileLoadFailure(e.toString()));
    }
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ProfileLoadSuccess) {
        emit(ProfileUpdateInProgress(currentState.user));
        
        await _profileRepository.updateUserProfile(
          event.user.id,
          updates: event.updates,
        );
        
        // The stream will update the state automatically
      }
    } catch (e) {
      final currentState = state;
      if (currentState is ProfileLoadSuccess) {
        emit(ProfileUpdateFailure(
          message: e.toString(),
          user: currentState.user,
        ));
      } else {
        emit(ProfileLoadFailure(e.toString()));
      }
    }
  }

  Future<void> _onProfilePictureUploadRequested(
    ProfilePictureUploadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ProfileLoadSuccess) {
        emit(ProfilePictureUploadInProgress(
          user: currentState.user,
          progress: 0.0,
        ));

        // Upload the file and get the download URL
        final imageUrl = await _profileRepository.uploadProfilePicture(
          imageFile: event.imageFile,
          onProgress: (progress) {
            add(ProfilePictureUploadProgress(progress));
          },
        );

        // Update the user's profile with the new image URL
        await _profileRepository.updateUserProfile(
          currentState.user.id,
          updates: {'profileImageUrl': imageUrl},
        );
      }
    } catch (e) {
      final currentState = state;
      if (currentState is ProfileLoadSuccess) {
        emit(ProfilePictureUploadFailure(
          message: e.toString(),
          user: currentState.user,
        ));
      } else {
        emit(ProfileLoadFailure(e.toString()));
      }
    }
  }

  Future<void> _onProfilePictureDeleteRequested(
    ProfilePictureDeleteRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfilePictureDeleteInProgress(event.user));
      
      await _profileRepository.deleteProfilePicture(event.user.id);
      
      // Update the user's profile to remove the image URL
      await _profileRepository.updateUserProfile(
        event.user.id,
        updates: {'profileImageUrl': null},
      );
      
    } catch (e) {
      emit(ProfilePictureDeleteFailure(
        message: e.toString(),
        user: event.user,
      ));
    }
  }

  void _onProfileResetRequested(
    ProfileResetRequested event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileInitial());
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}
