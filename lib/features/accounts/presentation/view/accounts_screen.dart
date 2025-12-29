import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/theme/gaps.dart';
import 'package:account_atlas/features/accounts/domain/accounts_enums.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef AccountIconConfig = ({IconData icon, Color bg});

//TODO: 나중에 ko도 만들 것
const Map<AccountProvider, AccountIconConfig> accountIconMap = {
  AccountProvider.email: (
    icon: FontAwesomeIcons.envelope,
    bg: AppColor.primary,
  ),
  AccountProvider.phone: (icon: FontAwesomeIcons.phone, bg: AppColor.secondary),
  AccountProvider.google: (
    icon: FontAwesomeIcons.google,
    bg: Color(0xff4285F4),
  ),
  AccountProvider.apple: (icon: FontAwesomeIcons.apple, bg: Color(0xff000000)),
  AccountProvider.github: (
    icon: FontAwesomeIcons.github,
    bg: Color(0xff181717),
  ),
  AccountProvider.facebook: (
    icon: FontAwesomeIcons.facebook,
    bg: Color(0xFF0866FF),
  ),
  AccountProvider.whatsapp: (
    icon: FontAwesomeIcons.whatsapp,
    bg: Color(0xFF25D366),
  ),
  AccountProvider.others: (
    icon: FontAwesomeIcons.circleQuestion,
    bg: Color(0xFF6D1ED4),
  ),
};

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('My Accounts')),
        body: Padding(
          padding: EdgeInsets.all(AppSpacing.basic),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //TODO: accounts를 전체 list를 얻고, map혹은 for in을 이용해 _AccountListItem으로 구성된 list 생성
                _AccountListItem(
                  identifier: "Hello@gmail.com",
                  provider: AccountProvider.google,
                  totalServices: 10,
                  bill: 120,
                  currency: Currency.ko,
                ),
                Gaps.v16,
                _AccountListItem(
                  identifier: "Hello@gmail.com",
                  provider: AccountProvider.github,
                  totalServices: 10,
                  bill: 120,
                  currency: Currency.ko,
                ),
                Gaps.v16,
                _AccountListItem(
                  identifier: "Hello@gmail.com",
                  provider: AccountProvider.whatsapp,
                  totalServices: 10,
                  bill: 120,
                  currency: Currency.ko,
                ),
                Gaps.v16,
                _AccountListItem(
                  identifier: "01044445555",
                  provider: AccountProvider.phone,
                  totalServices: 10,
                  bill: 120,
                  currency: Currency.ko,
                ),
                Gaps.v16,
                _AccountListItem(
                  identifier: "nice123@outlook.com",
                  provider: AccountProvider.others,
                  totalServices: 10,
                  bill: 120,
                  currency: Currency.ko,
                ),
                Gaps.v16,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountListItem extends StatelessWidget {
  final String identifier;
  final AccountProvider provider;
  final int totalServices;
  final int bill;
  final Currency currency;

  const _AccountListItem({
    required this.identifier,
    required this.provider,
    required this.totalServices,
    required this.bill,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final currencyMark = currency == Currency.en ? '\$' : "₩";
    final t = Theme.of(context).textTheme;

    //TODO: GoRouter를 활용해 account_detail_screen으로 이동
    void onMoveDetail() {}

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onMoveDetail,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.basic,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.lg),
            boxShadow: [
              BoxShadow(
                blurRadius: AppSpacing.sm,
                offset: Offset(0, AppSpacing.xs),
                color: AppColor.black.withValues(alpha: 0.05),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: AppSpacing.xl + AppSpacing.xl,
                    height: AppSpacing.xl + AppSpacing.xl,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.xl + AppSpacing.xl,
                      ),
                      color: accountIconMap[provider]!.bg,
                    ),
                    child: Center(
                      child: Icon(
                        accountIconMap[provider]!.icon,
                        size: AppSpacing.xl,
                        color: AppColor.white,
                      ),
                    ),
                  ),
                  Gaps.h16,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(identifier, style: t.titleSmall),
                      Gaps.v8,
                      Container(
                        padding: EdgeInsets.all(AppSpacing.xs),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSpacing.xs),
                          color: accountIconMap[provider]!.bg,
                        ),
                        child: Text(
                          provider.dbCode,
                          style: TextStyle(
                            color: AppColor.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Gaps.v24,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$totalServices services'),
                  Text('$currencyMark$bill / mo'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
