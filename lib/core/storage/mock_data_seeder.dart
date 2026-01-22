import 'dart:math';

import 'package:account_atlas/core/storage/app_database.dart';
import 'package:account_atlas/features/accounts/data/dtos/account_local_dto.dart';
import 'package:account_atlas/features/services/data/dtos/plan_local_dto.dart';
import 'package:account_atlas/features/services/data/dtos/service_local_dto.dart';
import 'package:sqflite/sqflite.dart';

class MockDataSeeder {
  static Future<void> seedIfEmpty() async {
    final db = await AppDatabase.instance.database;
    final accountCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM accounts'),
        ) ??
        0;
    final serviceCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM account_services'),
        ) ??
        0;

    if (accountCount > 0 || serviceCount > 0) {
      return;
    }

    final now = DateTime.now();
    final random = Random();

    // 1. 계정 생성 (가입일 랜덤: 최근 1년 ~ 10일 전)
    final accounts = [
      AccountLocalDto(
        identifier: 'coremagic@gmail.com',
        provider: 'Gmail',
        createdAt: now
            .subtract(Duration(days: random.nextInt(350) + 10))
            .millisecondsSinceEpoch,
      ),
      AccountLocalDto(
        identifier: 'nyamnyang@gmail.com',
        provider: 'Facebook',
        createdAt: now
            .subtract(Duration(days: random.nextInt(350) + 10))
            .millisecondsSinceEpoch,
      ),
      AccountLocalDto(
        identifier: '01044332222',
        provider: 'Whatsapp',
        createdAt: now
            .subtract(Duration(days: random.nextInt(350) + 10))
            .millisecondsSinceEpoch,
      ),
      AccountLocalDto(
        identifier: 'smalltide@naver.com',
        provider: 'Email',
        createdAt: now
            .subtract(Duration(days: random.nextInt(350) + 10))
            .millisecondsSinceEpoch,
      ),
      AccountLocalDto(
        identifier: 'sosmayday@outlook.com',
        provider: 'Apple',
        createdAt: now
            .subtract(Duration(days: random.nextInt(350) + 10))
            .millisecondsSinceEpoch,
      ),
      AccountLocalDto(
        identifier: 'power2000@naver.com',
        provider: 'Github',
        createdAt: now
            .subtract(Duration(days: random.nextInt(350) + 10))
            .millisecondsSinceEpoch,
      ),
      AccountLocalDto(
        identifier: 'corizaha@yahoo.com',
        provider: 'Others',
        createdAt: now
            .subtract(Duration(days: random.nextInt(350) + 10))
            .millisecondsSinceEpoch,
      ),
    ];

    // 계정당 서비스 갯수 랜덤 (7~15개)
    for (final account in accounts) {
      final accountId = await db.insert('accounts', account.toInsertMap());

      // 서비스 템플릿을 랜덤으로 섞어서 선택
      final shuffledServices = List.of(_serviceTemplates)..shuffle(random);
      final count = random.nextInt(9) + 7;
      final selectedServices = shuffledServices.take(count).toList();

      await _insertServicesForAccount(
        db: db,
        accountId: accountId,
        services: selectedServices,
      );
    }
  }

  static Future<void> _insertServicesForAccount({
    required Database db,
    required int accountId,
    required List<_MockService> services,
  }) async {
    final random = Random();
    final now = DateTime.now();

    for (final template in services) {
      // 가입일: 과거 2년 ~ 3일 전 사이 랜덤
      final createdAt = now
          .subtract(Duration(days: random.nextInt(700) + 3))
          .millisecondsSinceEpoch;

      final serviceId = await db.insert(
        'account_services',
        ServiceLocalDto(
          accountId: accountId,
          providedServiceKey: template.providedServiceKey,
          displayName: template.displayName,
          loginType: template.loginType,
          loginId: template.loginId,
          category: template.category,
          isPay: template.isPay,
          memo: template.memo,
          createdAt: createdAt,
        ).toInsertMap(),
      );

      // 유료 서비스일 때만 Plan 추가
      if (template.isPay == 1) {
        final billingCycle =
            template.billingCycle ?? 0; // 0: Monthly, 1: Yearly

        // 다음 결제일: 월간(1~30일 후), 연간(1~360일 후) 랜덤
        final daysUntilNext = billingCycle == 1
            ? random.nextInt(360) + 1
            : random.nextInt(28) + 1;

        final nextBillingDate = now
            .add(Duration(days: daysUntilNext))
            .millisecondsSinceEpoch;

        await db.insert(
          'plans',
          PlanLocalDto(
            accountServiceId: serviceId,
            currency: template.currency ?? 'USD',
            amount: template.amount ?? 0,
            billingCycle: billingCycle,
            nextBillingDate: nextBillingDate,
            createdAt: createdAt,
          ).toInsertMap(),
        );
      }
    }
  }
}

class _MockService {
  final String providedServiceKey;
  final String displayName;
  final String loginType;
  final String? loginId;
  final String category;
  final int isPay; // 0: Free, 1: Paid
  final String? memo;
  final int? amount; // Dollar Unit ($1 = 1)
  final int? billingCycle; // 0: Monthly, 1: Yearly
  final String? currency;

  const _MockService({
    required this.providedServiceKey,
    required this.displayName,
    required this.loginType,
    required this.loginId,
    required this.category,
    required this.isPay,
    this.memo,
    this.amount,
    this.billingCycle,
    this.currency,
  });
}

// JSON 데이터를 기반으로 재구성된 서비스 리스트
final List<_MockService> _serviceTemplates = [
  // --- Video ---
  _MockService(
    providedServiceKey: 'netflix',
    displayName: 'Netflix',
    loginType: 'email',
    loginId: 'user@netflix.com',
    category: 'video',
    isPay: 1,
    memo: 'Premium 4K',
    amount: 23,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'youtube_premium',
    displayName: 'YouTube Premium',
    loginType: 'google',
    loginId: 'user@gmail.com',
    category: 'video',
    isPay: 1,
    memo: 'Family',
    amount: 23,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'disney_plus',
    displayName: 'Disney+',
    loginType: 'email',
    loginId: 'fan@disney.com',
    category: 'video',
    isPay: 1,
    memo: 'No Ads',
    amount: 14,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'hbo_max',
    displayName: 'HBO Max',
    loginType: 'email',
    loginId: 'movie@hbo.com',
    category: 'video',
    isPay: 1,
    memo: 'Ad-Free',
    amount: 16,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'prime_video',
    displayName: 'Amazon Prime Video',
    loginType: 'amazon',
    loginId: 'shop@amazon.com',
    category: 'video',
    isPay: 1,
    memo: 'Video Only',
    amount: 9,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'apple_tv_plus',
    displayName: 'Apple TV+',
    loginType: 'apple',
    loginId: 'me@icloud.com',
    category: 'video',
    isPay: 1,
    memo: 'Monthly',
    amount: 10,
    billingCycle: 0,
    currency: 'USD',
  ),

  // --- Music ---
  _MockService(
    providedServiceKey: 'spotify',
    displayName: 'Spotify',
    loginType: 'email',
    loginId: 'music@spotify.com',
    category: 'music',
    isPay: 1,
    memo: 'Duo Plan',
    amount: 15,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'apple_music',
    displayName: 'Apple Music',
    loginType: 'apple',
    loginId: 'me@icloud.com',
    category: 'music',
    isPay: 1,
    memo: 'Individual',
    amount: 11,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'youtube_music',
    displayName: 'YouTube Music',
    loginType: 'google',
    loginId: 'user@gmail.com',
    category: 'music',
    isPay: 1,
    memo: 'Premium',
    amount: 11,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'amazon_music',
    displayName: 'Amazon Music',
    loginType: 'amazon',
    loginId: 'user@amazon.com',
    category: 'music',
    isPay: 1,
    memo: 'Unlimited',
    amount: 10,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'tidal',
    displayName: 'Tidal',
    loginType: 'email',
    loginId: 'audiophile@tidal.com',
    category: 'music',
    isPay: 1,
    memo: 'HiFi Plus',
    amount: 20,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'soundcloud',
    displayName: 'SoundCloud',
    loginType: 'social',
    loginId: 'indie_artist',
    category: 'music',
    isPay: 0,
    memo: 'Free listening',
    amount: null,
    billingCycle: null,
    currency: null,
  ), // Free
  // --- Shopping ---
  _MockService(
    providedServiceKey: 'amazon_prime',
    displayName: 'Amazon Prime',
    loginType: 'amazon',
    loginId: 'shop@amazon.com',
    category: 'shopping',
    isPay: 1,
    memo: 'Annual',
    amount: 139,
    billingCycle: 1,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'walmart_plus',
    displayName: 'Walmart+',
    loginType: 'email',
    loginId: 'shop@walmart.com',
    category: 'shopping',
    isPay: 1,
    memo: 'Monthly',
    amount: 13,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'uber_one',
    displayName: 'Uber One',
    loginType: 'email',
    loginId: 'taxi@uber.com',
    category: 'shopping',
    isPay: 1,
    memo: 'Monthly',
    amount: 10,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'doordash',
    displayName: 'DoorDash',
    loginType: 'email',
    loginId: 'food@doordash.com',
    category: 'shopping',
    isPay: 1,
    memo: 'DashPass',
    amount: 10,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'instacart_plus',
    displayName: 'Instacart+',
    loginType: 'email',
    loginId: 'food@insta.com',
    category: 'shopping',
    isPay: 1,
    memo: 'Yearly',
    amount: 99,
    billingCycle: 1,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'costco',
    displayName: 'Costco',
    loginType: 'email',
    loginId: 'user@costco.com',
    category: 'shopping',
    isPay: 1,
    memo: 'Gold Star',
    amount: 65,
    billingCycle: 1,
    currency: 'USD',
  ),

  // --- Tool ---
  _MockService(
    providedServiceKey: 'microsoft_365',
    displayName: 'Microsoft 365',
    loginType: 'microsoft',
    loginId: 'office@outlook.com',
    category: 'tool',
    isPay: 1,
    memo: 'Personal',
    amount: 7,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'google_one',
    displayName: 'Google One',
    loginType: 'google',
    loginId: 'drive@gmail.com',
    category: 'tool',
    isPay: 1,
    memo: '2TB',
    amount: 10,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'notion',
    displayName: 'Notion',
    loginType: 'email',
    loginId: 'note@notion.so',
    category: 'tool',
    isPay: 0,
    memo: 'Personal Free',
    amount: null,
    billingCycle: null,
    currency: null,
  ), // Free
  _MockService(
    providedServiceKey: 'dropbox',
    displayName: 'Dropbox',
    loginType: 'email',
    loginId: 'file@box.com',
    category: 'tool',
    isPay: 1,
    memo: 'Plus',
    amount: 12,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'icloud',
    displayName: 'iCloud+',
    loginType: 'apple',
    loginId: 'me@icloud.com',
    category: 'tool',
    isPay: 1,
    memo: '200GB',
    amount: 3,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'obsidian_sync',
    displayName: 'Obsidian Sync',
    loginType: 'email',
    loginId: 'writer@obsidian.md',
    category: 'tool',
    isPay: 1,
    memo: 'Sync',
    amount: 8,
    billingCycle: 0,
    currency: 'USD',
  ),

  // --- SNS ---
  _MockService(
    providedServiceKey: 'x',
    displayName: 'X',
    loginType: 'social',
    loginId: '@musk_fan',
    category: 'sns',
    isPay: 1,
    memo: 'Premium',
    amount: 8,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'linkedin',
    displayName: 'LinkedIn',
    loginType: 'email',
    loginId: 'job@linkedin.com',
    category: 'sns',
    isPay: 1,
    memo: 'Premium Career',
    amount: 40,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'discord',
    displayName: 'Discord',
    loginType: 'email',
    loginId: 'gamer#9999',
    category: 'sns',
    isPay: 1,
    memo: 'Nitro',
    amount: 10,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'snapchat',
    displayName: 'Snapchat',
    loginType: 'phone',
    loginId: '010-1234-5678',
    category: 'sns',
    isPay: 0,
    memo: 'Personal',
    amount: null,
    billingCycle: null,
    currency: null,
  ), // Free
  _MockService(
    providedServiceKey: 'telegram',
    displayName: 'Telegram',
    loginType: 'phone',
    loginId: '010-9876-5432',
    category: 'sns',
    isPay: 1,
    memo: 'Premium',
    amount: 5,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'twitch',
    displayName: 'Twitch',
    loginType: 'social',
    loginId: 'stream_fan',
    category: 'sns',
    isPay: 0,
    memo: 'Viewer',
    amount: null,
    billingCycle: null,
    currency: null,
  ), // Free
  // --- AI ---
  _MockService(
    providedServiceKey: 'gemini',
    displayName: 'Gemini',
    loginType: 'google',
    loginId: 'ai@google.com',
    category: 'ai',
    isPay: 1,
    memo: 'Advanced',
    amount: 20,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'chatgpt',
    displayName: 'ChatGPT',
    loginType: 'email',
    loginId: 'ai@openai.com',
    category: 'ai',
    isPay: 1,
    memo: 'Plus',
    amount: 20,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'claude',
    displayName: 'Claude',
    loginType: 'email',
    loginId: 'smart@anthropic.com',
    category: 'ai',
    isPay: 1,
    memo: 'Pro',
    amount: 20,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'perplexity',
    displayName: 'Perplexity',
    loginType: 'email',
    loginId: 'search@pplx.ai',
    category: 'ai',
    isPay: 1,
    memo: 'Pro',
    amount: 20,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'github_copilot',
    displayName: 'GitHub Copilot',
    loginType: 'github',
    loginId: 'dev_guru',
    category: 'ai',
    isPay: 1,
    memo: 'Individual',
    amount: 10,
    billingCycle: 0,
    currency: 'USD',
  ),

  // --- Game ---
  _MockService(
    providedServiceKey: 'xbox_game_pass',
    displayName: 'Xbox Game Pass',
    loginType: 'microsoft',
    loginId: 'play@xbox.com',
    category: 'game',
    isPay: 1,
    memo: 'Ultimate',
    amount: 20,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'playstation_plus',
    displayName: 'PlayStation Plus',
    loginType: 'sony',
    loginId: 'play@sony.com',
    category: 'game',
    isPay: 1,
    memo: 'Extra',
    amount: 15,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'nintendo_online',
    displayName: 'Nintendo Switch Online',
    loginType: 'nintendo',
    loginId: 'mario@nintendo.com',
    category: 'game',
    isPay: 1,
    memo: 'Individual Annual',
    amount: 20,
    billingCycle: 1,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'geforce_now',
    displayName: 'GeForce Now',
    loginType: 'email',
    loginId: 'cloud@nvidia.com',
    category: 'game',
    isPay: 1,
    memo: 'Priority',
    amount: 10,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'ea_play',
    displayName: 'EA Play',
    loginType: 'email',
    loginId: 'sports@ea.com',
    category: 'game',
    isPay: 1,
    memo: 'Monthly',
    amount: 6,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'roblox',
    displayName: 'Roblox',
    loginType: 'email',
    loginId: 'kid_gamer',
    category: 'game',
    isPay: 1,
    memo: 'Premium 450',
    amount: 5,
    billingCycle: 0,
    currency: 'USD',
  ),

  // --- Edu ---
  _MockService(
    providedServiceKey: 'duolingo',
    displayName: 'Duolingo',
    loginType: 'google',
    loginId: 'lang@duo.com',
    category: 'education',
    isPay: 1,
    memo: 'Super',
    amount: 7,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'coursera',
    displayName: 'Coursera',
    loginType: 'email',
    loginId: 'learn@coursera.org',
    category: 'education',
    isPay: 1,
    memo: 'Plus',
    amount: 59,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'masterclass',
    displayName: 'MasterClass',
    loginType: 'email',
    loginId: 'skill@master.com',
    category: 'education',
    isPay: 1,
    memo: 'Individual',
    amount: 120,
    billingCycle: 1,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'skillshare',
    displayName: 'Skillshare',
    loginType: 'email',
    loginId: 'create@skill.com',
    category: 'education',
    isPay: 1,
    memo: 'Annual',
    amount: 168,
    billingCycle: 1,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'grammarly',
    displayName: 'Grammarly',
    loginType: 'email',
    loginId: 'write@grammarly.com',
    category: 'education',
    isPay: 1,
    memo: 'Premium',
    amount: 144,
    billingCycle: 1,
    currency: 'USD',
  ),

  // --- Others ---
  _MockService(
    providedServiceKey: 'tinder',
    displayName: 'Tinder',
    loginType: 'phone',
    loginId: '010-5678-1234',
    category: 'others',
    isPay: 1,
    memo: 'Gold',
    amount: 25,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'strava',
    displayName: 'Strava',
    loginType: 'email',
    loginId: 'run@strava.com',
    category: 'others',
    isPay: 1,
    memo: 'Annual',
    amount: 80,
    billingCycle: 1,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'nordvpn',
    displayName: 'NordVPN',
    loginType: 'email',
    loginId: 'hide@vpn.com',
    category: 'others',
    isPay: 1,
    memo: '2-Year Plan',
    amount: 4,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'calm',
    displayName: 'Calm',
    loginType: 'email',
    loginId: 'relax@calm.com',
    category: 'others',
    isPay: 1,
    memo: 'Premium',
    amount: 15,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'nyt',
    displayName: 'The New York Times',
    loginType: 'email',
    loginId: 'news@nyt.com',
    category: 'others',
    isPay: 1,
    memo: 'All Access',
    amount: 25,
    billingCycle: 0,
    currency: 'USD',
  ),
  _MockService(
    providedServiceKey: 'peloton',
    displayName: 'Peloton',
    loginType: 'email',
    loginId: 'bike@peloton.com',
    category: 'others',
    isPay: 1,
    memo: 'App Membership',
    amount: 13,
    billingCycle: 0,
    currency: 'USD',
  ),
];
