import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._internal();

  static final AppDatabase instance = AppDatabase._internal();

  static const _dbName = "account_atlas_db";
  static const _dbVersion = 1;

  Database? _database;

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  //AppDatabase.instance.database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    //identifier: 계정 이름, 이메일, 전화번호
    //provider: 깃헙, facebook, gmail, naver, kakao, apple, x, outlook, yahoo...
    //차후 user_id 추가
    await db.execute('''
      CREATE TABLE accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        identifier TEXT NOT NULL,
        provider TEXT NOT NULL,
        created_at INTEGER NOT NULL
      );
    ''');

    //로그인 타입(아이디, 소셜, 전화번호,), 로그인 아이디(아이디 로그인일경우에만)
    //is_pay : sqflite에는 bool을 지원 안해주니 0과 1사용. 1일 경우 plans 생성
    await db.execute('''
      CREATE TABLE account_services (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        account_id INTEGER NOT NULL, 
        name TEXT NOT NULL,
        login_type TEXT NOT NULL,
        login_id TEXT,
        is_pay INTEGER NOT NULL,
        memo TEXT,
        created_at INTEGER NOT NULL
      );
    ''');

    // billing_cycle 0이면 monthly, 1이면 yearly
    // name -> 구독 모델 이름 (basic, premium, team..etc)
    await db.execute('''
      CREATE TABLE plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        service_id INTEGER NOT NULL,
        name TEXT,
        currency TEXT NOT NULL DEFAULT 'KRW',
        amount INTEGER NOT NULL,
        billing_cycle INTEGER NOT NULL,
        next_billing_date INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      );
    ''');
  }
}
