// ignore_for_file: unused_import

import 'package:agricultural_platform/screens/profile/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:agricultural_platform/l10n/app_localizations.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../models/user.dart';


class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final user = state is ProfileLoadSuccess
            ? state.user
            : (state is ProfileUpdateSuccess ? state.user : null);

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with edit button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizations.personalInformation,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (state is ProfileLoadSuccess && state.isCurrentUser)
                      TextButton.icon(
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: Text(localizations.editProfile),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                user: state.user,
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: const Size(0, 32),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Contact Information Section
                _buildSectionHeader(localizations.contactInformation),
                const SizedBox(height: 12),
                _buildInfoRow(
                    Icons.email_outlined, localizations.email, user.email),
                if (user.phoneNumber?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.phone_outlined, localizations.phone,
                      user.phoneNumber!),
                ],
                if (user.location?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    localizations.location,
                    user.location!,
                  ),
                ],

                // Bio Section
                if (user.bio?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 16),
                  _buildSectionHeader(localizations.about),
                  const SizedBox(height: 12),
                  Text(
                    user.bio!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],

                // Member Since
                const SizedBox(height: 16),
                _buildSectionHeader(localizations.memberSince),
                const SizedBox(height: 8),
                Text(
                  _formatDate(user.createdAt),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                ),

                // Social Links Section
                if (user.socialLinks?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 16),
                  _buildSectionHeader(localizations.connectWithMe),
                  const SizedBox(height: 12),
                  _buildSocialLinks(user.socialLinks!),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              SelectableText(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLinks(Map<String, String> socialLinks) {
    final socialIcons = {
      'facebook': Icons.facebook_rounded,
      'twitter': Icons.public,
      'instagram': Icons.camera_alt_rounded,
      'linkedin': Icons.business_center_rounded,
      'website': Icons.language_rounded,
    };

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: socialLinks.entries.map((entry) {
        final platform = entry.key.toLowerCase();
        final url = entry.value;
        final icon = socialIcons[platform] ?? Icons.link;

        return Tooltip(
          message: platform,
          child: InkWell(
            onTap: () => _launchURL(url),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: _getSocialIconColor(platform)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getSocialIconColor(String platform) {
    switch (platform) {
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'instagram':
        return const Color(0xFFE1306C);
      case 'linkedin':
        return const Color(0xFF0077B5);
      default:
        return Colors.grey[700]!;
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static String _formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  static String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }
}
