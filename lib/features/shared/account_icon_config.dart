import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/features/accounts/domain/accounts_enums.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef AccountIconConfig = ({IconData icon, Color bg});

//TODO: add accountIconMap for korean
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
