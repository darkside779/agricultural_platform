import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateThemeMode extends SettingsEvent {
  final ThemeMode themeMode;

  const UpdateThemeMode(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

class UpdateNotifications extends SettingsEvent {
  final bool enableNotifications;

  const UpdateNotifications(this.enableNotifications);

  @override
  List<Object> get props => [enableNotifications];
}

class UpdateLanguage extends SettingsEvent {
  final String languageCode;

  const UpdateLanguage(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

// States
class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final bool enableNotifications;
  final String languageCode;
  final bool isLoading;
  final String? error;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.enableNotifications = true,
    this.languageCode = 'en',
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? enableNotifications,
    String? languageCode,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      languageCode: languageCode ?? this.languageCode,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        enableNotifications,
        languageCode,
        isLoading,
        error,
      ];
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  static const String _settingsKey = 'app_settings';

  SettingsBloc() : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateThemeMode>(_onUpdateThemeMode);
    on<UpdateNotifications>(_onUpdateNotifications);
    on<UpdateLanguage>(_onUpdateLanguage);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson != null) {
        final settings = jsonDecode(settingsJson) as Map<String, dynamic>;

        emit(state.copyWith(
          themeMode: ThemeMode.values[settings['themeMode'] ?? 0],
          enableNotifications: settings['enableNotifications'] ?? true,
          languageCode: settings['languageCode'] ?? 'en',
          isLoading: false,
        ));
      } else {
        // Default settings
        await _saveSettings(state);
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to load settings: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> _onUpdateThemeMode(
    UpdateThemeMode event,
    Emitter<SettingsState> emit,
  ) async {
    final newState = state.copyWith(themeMode: event.themeMode);
    await _saveSettings(newState);
    emit(newState);
  }

  Future<void> _onUpdateNotifications(
    UpdateNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    final newState =
        state.copyWith(enableNotifications: event.enableNotifications);
    await _saveSettings(newState);
    emit(newState);
  }

  Future<void> _onUpdateLanguage(
    UpdateLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    final newState = state.copyWith(languageCode: event.languageCode);
    await _saveSettings(newState);
    emit(newState);
  }

  Future<void> _saveSettings(SettingsState state) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settings = {
        'themeMode': state.themeMode.index,
        'enableNotifications': state.enableNotifications,
        'languageCode': state.languageCode,
      };
      await prefs.setString(_settingsKey, jsonEncode(settings));
    } catch (e) {
      // Handle error
      rethrow;
    }
  }
}

// Theme mode extension for better readability
extension ThemeModeExtension on ThemeMode {
  String get name {
    switch (this) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }
}
