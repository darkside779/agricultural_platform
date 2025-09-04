// ignore_for_file: unused_import

import 'package:agricultural_platform/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agricultural_platform/blocs/profile/profile_bloc.dart';
import 'package:agricultural_platform/models/user.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_stats.dart';
import 'widgets/profile_actions.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  final bool isCurrentUser;

  const ProfileScreen({
    super.key,
    required this.userId,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        profileRepository: context.read<ProfileRepository>(),
        currentUserId: userId,
      )..add(
          ProfileLoadRequested(userId: userId, isCurrentUser: isCurrentUser)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            if (isCurrentUser)
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Navigate to settings
                },
              ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoadSuccess) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Header with cover and profile image
                    ProfileHeader(
                      user: state.user,
                      isCurrentUser: isCurrentUser,
                    ),

                    // User Info Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and Role
                          Text(
                            state.user.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.user.role.toString().split('.').last,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 16),

                          // Bio
                          if (state.user.bio != null &&
                              state.user.bio!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                state.user.bio!,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),

                          // Stats (Posts, Followers, Following)
                          const ProfileStats(),
                          const SizedBox(height: 16),

                          // Action Buttons
                          ProfileActions(
                            isCurrentUser: isCurrentUser,
                            user: state.user,
                          ),
                        ],
                      ),
                    ),

                    // Additional Info
                    const Divider(),
                    const ProfileInfoCard(),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            } else if (state is ProfileLoadFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Failed to load profile: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(
                              ProfileLoadRequested(
                                userId: userId,
                                isCurrentUser: isCurrentUser,
                              ),
                            );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileUpdateInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileUpdateFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Update failed: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(
                              ProfileLoadRequested(
                                userId: userId,
                                isCurrentUser: isCurrentUser,
                              ),
                            );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
