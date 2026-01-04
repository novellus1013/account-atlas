import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:account_atlas/core/theme/gaps.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  final String _version = '1.0.0';

  const SettingsScreen({super.key});

  final String _termsUrl = 'https://google.com"=';
  final String _privacyUrl = 'https://naver.com';
  final String _supportEmail = 'novluslab@proton.me';
  final String _support =
      'mailto:novluslab@proton.me?subject=문의사항&body=아래와 같은 문제가 발생했습니다.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(AppSpacing.basic),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _SettingTitle(title: '계정'),
              // _SettingItem(title: '사용자 이름'),
              // _SettingItem(title: '이메일'),
              // _SettingItem(title: '로그아웃'),

              // _SettingTitle(title: '데이터 관리'),
              // _SettingItem(title: '데이터 저장하기'),
              // _SettingItem(title: '데이터 불러오기'),
              _SettingTitle(title: '더 보기'),
              _SettingItem(
                title: '개인정보 보호정책',
                onTap: () async {
                  final url = Uri.parse(_privacyUrl);
                  if (await canLaunchUrl(url)) {
                    launchUrl(url);
                  } else {
                    debugPrint("Can't open privacy");
                  }
                },
              ),
              _SettingItem(
                title: '서비스 이용 약관',
                onTap: () async {
                  final url = Uri.parse(_termsUrl);
                  if (await canLaunchUrl(url)) {
                    launchUrl(url);
                  } else {
                    debugPrint("Can't open terms");
                  }
                },
              ),

              _SettingTitle(title: '지원'),
              _SettingItem(title: '버전', subText: _version),
              _SettingItem(
                title: '문의하기',
                subText: _supportEmail,
                onTap: () async {
                  final url = Uri.parse(_support);
                  if (await canLaunchUrl(url)) {
                    launchUrl(url);
                  } else {
                    debugPrint("Can't open support mailto");
                  }
                },
              ),

              // _SettingItem(
              //   title: '계정 삭제',
              //   subText: '계정을 영구적으로 삭제하는 경우',
              //   color: AppColor.error,
              //   onTap: () {},
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingTitle extends StatelessWidget {
  final String title;

  const _SettingTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gaps.v12,
        Text(title, style: TextStyle(color: AppColor.primary)),
        Gaps.v24,
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String title;
  final String? subText;
  final VoidCallback? onTap;
  final Color? color;

  const _SettingItem({
    required this.title,
    this.subText,
    this.onTap,
    // ignore: unused_element_parameter
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color ?? AppColor.black,
              fontSize: AppTextSizes.base,
            ),
          ),
          if (subText != null) ...[
            Gaps.v4,
            Text(
              subText!,
              style: TextStyle(
                color: AppColor.textGrey,
                fontSize: AppTextSizes.md,
              ),
            ),
          ],
          Gaps.v24,
        ],
      ),
    );
  }
}
