import 'package:ammentor/screen/profile/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/theme.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ammentor/screen/auth/provider/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(userEmailProvider);

    if (email == null) {
      return const Center(child: Text("Email not found. Please login."));
    }

    final userAsync = ref.watch(userProvider(email));
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.subheading(context)),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (user) {
          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              children: [
                // --- Profile card
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: AppColors.darkgrey,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.avatarUrl),
                        radius: 40,
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: AppTextStyles.body(context)),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              user.email,
                              style: AppTextStyles.caption(context),
                            ),
                            Text(
                              user.role,
                              style: AppTextStyles.caption(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // --- Badges
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: AppColors.darkgrey,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            HugeIcons.strokeRoundedCheckmarkBadge02,
                            color: Colors.white,
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          Text(
                            'Badges Gained',
                            style: AppTextStyles.body(context),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Wrap(
                        spacing: 10,
                        children:
                            user.badges.map((badge) {
                              return CircleAvatar(
                                backgroundColor: AppColors.primary,
                                radius: 20,
                                child: Text(
                                  badge[0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                // --- Points
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: AppColors.darkgrey,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Row(
                    children: [
                      const Icon(HugeIcons.strokeRoundedAnalytics01),
                      SizedBox(width: screenWidth * 0.05),
                      Text(
                        "Points Earned: ",
                        style: AppTextStyles.body(context),
                      ),
                      Text(
                        user.points.toString(),
                        style: AppTextStyles.body(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('user_email');
                    ref.read(userEmailProvider.notifier).state = null;
                    Navigator.of(context).popUntil((route) => route.isFirst); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorDark,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.3,
                      vertical: screenHeight * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: AppTextStyles.button(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
