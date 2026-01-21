import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:account_atlas/core/theme/gaps.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String _version = '1.0.0';
  static const String _termsUrl = 'https://accountatlas.vercel.app/terms';
  static const String _privacyUrl = 'https://accountatlas.vercel.app/privacy';
  static const String _aboutUrl = 'https://accountatlas.vercel.app/#about';
  static const String _contactEmail = 'noveluslab@proton.me';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey50,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColor.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.basic),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // General Settings
              _SettingsSection(
                title: 'General',
                children: [
                  _SettingsTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'English',
                    showChevron: false,
                    onTap: () {},
                  ),
                  Divider(height: 1, color: AppColor.borderGrey),
                  _SettingsTile(
                    icon: Icons.attach_money,
                    title: 'Currency',
                    subtitle: 'USD (\$)',
                    showChevron: false,
                    onTap: () {},
                  ),
                ],
              ),
              Gaps.v24,

              // Support
              _SettingsSection(
                title: 'Support',
                children: [
                  _SettingsTile(
                    icon: Icons.email_outlined,
                    title: 'Contact Us',
                    subtitle: _contactEmail,
                    onTap: () => _launchEmail(_contactEmail),
                  ),
                ],
              ),
              Gaps.v24,

              // Legal & Information
              _SettingsSection(
                title: 'Legal & Information',
                children: [
                  _SettingsTile(
                    title: 'Terms of Service',
                    onTap: () => _launchUrl(_termsUrl),
                  ),
                  Divider(height: 1, color: AppColor.borderGrey),
                  _SettingsTile(
                    title: 'Privacy Policy',
                    onTap: () => _launchUrl(_privacyUrl),
                  ),
                  Divider(height: 1, color: AppColor.borderGrey),
                  _SettingsTile(
                    title: 'About Account Atlas',
                    onTap: () {
                      _launchUrl(_aboutUrl);
                    },
                  ),
                ],
              ),
              Gaps.v24,

              // Trademark Disclaimer
              _buildTrademarkNotice(),
              Gaps.v24,

              // Version Info
              Center(
                child: Column(
                  children: [
                    Text(
                      'Account Atlas',
                      style: TextStyle(
                        color: AppColor.grey400,
                        fontSize: AppTextSizes.md,
                      ),
                    ),
                    Gaps.v4,
                    Text(
                      'Version $_version',
                      style: TextStyle(
                        color: AppColor.grey400,
                        fontSize: AppTextSizes.sm,
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.v32,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrademarkNotice() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB), // amber-50
        border: Border.all(color: const Color(0xFFFCD34D)), // amber-200
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      padding: const EdgeInsets.all(AppSpacing.basic),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFD97706), // amber-600
            size: 20,
          ),
          Gaps.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trademark Notice',
                  style: TextStyle(
                    color: Color(0xFF78350F), // amber-900
                    fontSize: AppTextSizes.md,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.v4,
                Text(
                  'All logos and trademarks displayed in this app are the property of their respective owners. Account Atlas is not affiliated with, endorsed by, or sponsored by any of the service providers shown.',
                  style: TextStyle(
                    color: const Color(0xFF92400E), // amber-800
                    fontSize: AppTextSizes.sm,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.grey200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.basic),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColor.grey900,
                fontSize: AppTextSizes.base,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColor.borderGrey),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final bool showChevron;
  final VoidCallback? onTap;

  const _SettingsTile({
    this.icon,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.showChevron = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.basic),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: AppColor.grey400),
              Gaps.h12,
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor ?? AppColor.grey900,
                      fontSize: AppTextSizes.base,
                    ),
                  ),
                  if (subtitle != null) ...[
                    Gaps.v4,
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: AppColor.grey500,
                        fontSize: AppTextSizes.md,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColor.grey400,
              ),
          ],
        ),
      ),
    );
  }
}
