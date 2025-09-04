// lib/main.dart
// ignore_for_file: unused_import, avoid_print, unused_local_variable

import 'package:agricultural_platform/blocs/auth/auth_bloc.dart';
import 'package:agricultural_platform/config/hive_config.dart';
import 'package:agricultural_platform/l10n/app_localizations.dart';
import 'package:agricultural_platform/repositories/profile_repository.dart';
import 'package:agricultural_platform/services/profile_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Hive
    await HiveConfig.init();

    // Get the user box for local storage
    final userBox = HiveConfig.getUserBox();

    // Create service and repository instances
    final authService = AuthService();
    final profileService = ProfileService();
    final profileRepository = ProfileRepositoryImpl();
 
    runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthService>.value(value: authService),
          RepositoryProvider<ProfileService>.value(value: profileService),
          RepositoryProvider<ProfileRepository>.value(value: profileRepository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(
                authService: authService,
                profileRepository: profileRepository,
              )..add(const AuthCheckRequested()),
            ),
          ],
          child: const MyApp(),
        ),
      ),
    );
  } catch (e) {
    print('Error during app initialization: $e');
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agricultural Platform',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('es', ''), // Spanish
        Locale('fr', ''), // French
        Locale('hi', ''), // Hindi
        Locale('ar', ''), // Arabic
      ],
      home: const AgriculturalPlatformApp(),
    );
  }
}
