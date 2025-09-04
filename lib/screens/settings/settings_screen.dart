// ignore_for_file: deprecated_member_use

import 'package:agricultural_platform/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../blocs/settings/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: BlocProvider(
        create: (context) => SettingsBloc()..add(LoadSettings()),
        child: const SettingsView(),
      ),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(child: Text('Error: ${state.error}'));
        }

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: [
            _buildSectionHeader(AppLocalizations.of(context)!.appearance),
            _ThemeSettingTile(themeMode: state.themeMode),
            const Divider(height: 1),
            _buildSectionHeader(AppLocalizations.of(context)!.notifications),
            _NotificationSettingTile(
              enabled: state.enableNotifications,
            ),
            const Divider(height: 1),
            _buildSectionHeader(AppLocalizations.of(context)!.language),
            _LanguageSettingTile(languageCode: state.languageCode),
            const Divider(height: 1),
            _buildSectionHeader(AppLocalizations.of(context)!.account),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.signOut),
              onTap: () {
                // TODO: Implement sign out
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ThemeSettingTile extends StatelessWidget {
  final ThemeMode themeMode;

  const _ThemeSettingTile({required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.brightness_medium),
      title: Text(AppLocalizations.of(context)!.theme),
      subtitle: Text(themeMode.name),
      onTap: () => _showThemeDialog(context),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(AppLocalizations.of(context)!.systemDefault),
              value: ThemeMode.system,
              groupValue: themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  settingsBloc.add(UpdateThemeMode(value));
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(AppLocalizations.of(context)!.light),
              value: ThemeMode.light,
              groupValue: themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  settingsBloc.add(UpdateThemeMode(value));
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(AppLocalizations.of(context)!.dark),
              value: ThemeMode.dark,
              groupValue: themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  settingsBloc.add(UpdateThemeMode(value));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationSettingTile extends StatelessWidget {
  final bool enabled;

  const _NotificationSettingTile({required this.enabled});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(AppLocalizations.of(context)!.enableNotifications),
      subtitle: Text(AppLocalizations.of(context)!.receiveAppNotifications),
      secondary: const Icon(Icons.notifications_none),
      value: enabled,
      onChanged: (value) {
        context.read<SettingsBloc>().add(UpdateNotifications(value));
      },
    );
  }
}

class _LanguageSettingTile extends StatelessWidget {
  final String languageCode;

  const _LanguageSettingTile({required this.languageCode});

  @override
  Widget build(BuildContext context) {
    final languages = {
      'en': AppLocalizations.of(context)!.english,
      'es': AppLocalizations.of(context)!.spanish,
      'fr': AppLocalizations.of(context)!.french,
      'hi': AppLocalizations.of(context)!.hindi,
      'ar': AppLocalizations.of(context)!.arabic,
    };

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(AppLocalizations.of(context)!.language),
      subtitle: Text(
          languages[languageCode] ?? AppLocalizations.of(context)!.english),
      onTap: () => _showLanguageDialog(context, languages),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    Map<String, String> languages,
  ) {
    final settingsBloc = context.read<SettingsBloc>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectLanguage),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final code = languages.keys.elementAt(index);
              final name = languages[code]!;

              return RadioListTile<String>(
                title: Text(name),
                value: code,
                groupValue: languageCode,
                onChanged: (String? value) {
                  if (value != null) {
                    settingsBloc.add(UpdateLanguage(value));
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
