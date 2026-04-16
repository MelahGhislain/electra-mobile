import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/services/app_info_service.dart';
import 'package:flutter/material.dart';
import 'package:electra/presentation/settings/widgets/profile_header_card.dart';
import 'package:electra/presentation/settings/widgets/settings_section_header.dart';
import 'package:electra/presentation/settings/widgets/settings_tile.dart';
import 'package:electra/presentation/settings/widgets/settings_toggle_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final version = await AppInfoService.getVersion();
    setState(() {
      _version = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 0,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            ProfileHeaderCard(
              name: "Ethan Cole",
              email: "ethancoleux@gmail.com",
              onEditPressed: () {
                // Navigate to edit profile or show dialog
              },
            ),
            // GENERAL Section
            const SettingsSectionHeader(title: 'General'),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.dividerLight),
              ),
              child: Column(
                children: [
                  SettingsTile(
                    icon: Icons.palette_outlined,
                    title: 'Theme',
                    subtitle: 'Light',
                    showDivider: true,
                    showChevron: true,
                  ),
                  SettingsTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'System Default',
                    showDivider: true,
                    showChevron: true,
                  ),
                  SettingsTile(
                    icon: Icons.folder_outlined,
                    title: 'Currency',
                    subtitle: 'USD',
                    showChevron: true,
                    showDivider: true,
                  ),
                  SettingsToggleTile(
                    icon: Icons.notifications_outlined,
                    title: 'Push Notifications',
                    subtitle: 'Get remainders and updates',
                    value: false,
                    showDivider: true,
                  ),
                  SettingsTile(
                    icon: Icons.wallet,
                    title: 'Buget & Income',
                    subtitle: 'Manage your budget and income',
                    showChevron: true,
                  ),
                ],
              ),
            ),


            // GENERAL Section
            const SettingsSectionHeader(title: 'Help'),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.dividerLight),
              ),
              child: Column(
                children: [
                  SettingsTile(
                    icon: Icons.mail_outline,
                    title: 'Support',
                    subtitle: 'Contact our support team',
                    showDivider: true,
                    showChevron: true,
                  ),
                  SettingsTile(
                    icon: Icons.language,
                    title: 'Documentation',
                    subtitle: 'Learn how to use the app',
                    showDivider: true,
                    showChevron: true,
                  ),
                  
                  SettingsTile(
                    icon: Icons.wallet,
                    title: 'Suggest Product Improvement',
                    subtitle: 'Share your feedback to us improve the app',
                    showChevron: true,
                  ),
                ],
              ),
            ),

            // About Section
            const SettingsSectionHeader(title: 'About'),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.dividerLight),
              ),
              child: Column(
                children: [
                  SettingsTile(
                    icon: Icons.info_outline,
                    title: 'Version',
                    subtitle: _version,
                    showChevron: true,
                    showDivider: true,
                  ),
                  SettingsTile(
                    icon: Icons.map_outlined,
                    title: 'Setup Guide',
                    subtitle: 'New her? Start with this',
                    showDivider: true,
                    showChevron: true,
                  ),
                  SettingsTile(
                    icon: Icons.delete,
                    title: 'Delete',
                    subtitle: 'New her? Start with this',
                    showDivider: true,
                    showChevron: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
