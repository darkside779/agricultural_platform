// ignore_for_file: deprecated_member_use, unused_import

import 'package:agricultural_platform/screens/profile/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../models/user.dart';

class ProfileActions extends StatelessWidget {
  final bool isCurrentUser;
  final User user;

  const ProfileActions({
    super.key,
    required this.isCurrentUser,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final isLoading = state is ProfileUpdateInProgress ||
            state is ProfilePictureUploadInProgress ||
            state is ProfilePictureDeleteInProgress;

        if (!isCurrentUser) {
          return _buildFollowButton(context, isLoading);
        }

        return Column(
          children: [
            // Edit Profile Button
            _buildActionButton(
              context,
              icon: Icons.edit_outlined,
              label: 'Edit Profile',
              isLoading: isLoading,
              onPressed: () {
                // Navigate to edit profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: user),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Change Profile Picture
            _buildActionButton(
              context,
              icon: Icons.camera_alt_outlined,
              label: 'Change Photo',
              isLoading: isLoading,
              onPressed: () => _showImageSourceDialog(context),
            ),
            const SizedBox(height: 12),

            // Settings Button
            _buildActionButton(
              context,
              icon: Icons.settings_outlined,
              label: 'Settings',
              isLoading: isLoading,
              onPressed: () {
                // Navigate to settings screen
                // Navigator.pushNamed(context, '/settings');
              },
            ),
            const SizedBox(height: 12),

            // Logout Button
            _buildActionButton(
              context,
              icon: Icons.logout,
              label: 'Logout',
              isDestructive: true,
              isLoading: isLoading,
              onPressed: () => _showLogoutConfirmation(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFollowButton(BuildContext context, bool isLoading) {
    return _buildActionButton(
      context,
      icon: Icons.person_add,
      label: 'Follow',
      isLoading: isLoading,
      onPressed: () {
        // Handle follow/unfollow logic
        // context.read<ProfileBloc>().add(FollowUserRequested(user.id));
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isDestructive = false,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                icon,
                color:
                    isDestructive ? Theme.of(context).colorScheme.error : null,
              ),
        label: Text(
          label,
          style: TextStyle(
            color: isDestructive ? Theme.of(context).colorScheme.error : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: isDestructive
              ? BorderSide(color: Theme.of(context).colorScheme.error)
              : null,
        ),
      ),
    );
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null && context.mounted) {
        context
            .read<ProfileBloc>()
            .add(ProfilePictureUploadRequested(pickedFile));
      }
    }
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed && context.mounted) {
      // Handle logout
      // context.read<AuthBloc>().add(LogoutRequested());
    }
  }
}
