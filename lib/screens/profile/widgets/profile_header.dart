// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../models/user.dart';
import 'package:agricultural_platform/l10n/app_localizations.dart';

class ProfileHeader extends StatelessWidget {
  final User user;
  final bool isCurrentUser;
  final VoidCallback? onEditPressed;
  final VoidCallback? onMessagePressed;
  final VoidCallback? onFollowPressed;
  final int postCount;
  final int followersCount;
  final int followingCount;

  const ProfileHeader({
    super.key,
    required this.user,
    this.isCurrentUser = false,
    this.onEditPressed,
    this.onMessagePressed,
    this.onFollowPressed,
    this.postCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
  });

  void _handleImageTap(BuildContext context) {
    if (isCurrentUser) {
      showModalBottomSheet(
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () => _pickImage(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () => _pickImage(context, ImageSource.camera),
            ),
            if (user.profileImageUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove photo',
                    style: TextStyle(color: Colors.red)),
                onTap: () => _deleteImage(context),
              ),
          ],
        ),
      );
    }
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        if (!context.mounted) return;
        context.read<ProfileBloc>().add(
              ProfilePictureUploadRequested(pickedFile),
            );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void _deleteImage(BuildContext context) {
    context.read<ProfileBloc>().add(
          ProfilePictureDeleteRequested(user),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Image with edit button
          Stack(
            children: [
              GestureDetector(
                onTap: () => _handleImageTap(context),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  backgroundImage: user.profileImageUrl != null
                      ? CachedNetworkImageProvider(user.profileImageUrl!)
                      : null,
                  child: user.profileImageUrl == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              if (isCurrentUser)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // User name and role
          Text(
            user.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getRoleName(user.role, localizations),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                count: postCount,
                label: localizations.posts,
              ),
              _StatItem(
                count: followersCount,
                label: localizations.followers,
              ),
              _StatItem(
                count: followingCount,
                label: localizations.following,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _getRoleName(UserRole role, AppLocalizations localizations) {
    switch (role) {
      case UserRole.farmer:
        return localizations.farmer;
      case UserRole.merchant:
        return localizations.merchant;
      case UserRole.expert:
        return localizations.expert;
      case UserRole.admin:
        return localizations.admin;
      case UserRole.guest:
        return localizations.guest;
      case UserRole.researcher:
        return localizations.researcher;
      case UserRole.consultant:
        return localizations.consultant;
      case UserRole.cooperativeManager:
        return localizations.cooperativeManager;
      case UserRole.company:
        return localizations.company;
      case UserRole.user:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}

class _StatItem extends StatelessWidget {
  final int count;
  final String label;

  const _StatItem({
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
