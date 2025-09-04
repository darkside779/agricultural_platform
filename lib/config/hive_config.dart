import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:agricultural_platform/models/user.dart';

class HiveConfig {
  static Future<void> init() async {
    // Initialize Hive with the app's document directory
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    // Register Hive adapters
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(UserRoleAdapter());

    // Open the user box
    await Hive.openBox<User>('users');
  }

  // Helper method to get the user box
  static Box<User>? getUserBox() {
    try {
      return Hive.box<User>('users');
    } catch (e) {
      return null;
    }
  }

  // Clear all Hive data (useful for testing)
  static Future<void> clearAll() async {
    await Hive.box('users').clear();
  }

  // Close all Hive boxes
  static Future<void> close() async {
    await Hive.close();
  }
}
