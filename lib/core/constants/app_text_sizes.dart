class AppTextSizes {
  const AppTextSizes._(); // private constructor

  //기본적인 폰트 크기, 디자인에 따라 달라지는 fontWeight는 주석으로 추천 내용만 명시
  //기본 설정 w400, 14.0 px

  /// 타임스탬프, 아주 작은 보조 텍스트, 기본 or 연하게 w300
  static const double xs = 10.0;

  /// 작은 라벨, 입력 필드 설명 텍스트, 기본 or 약간 강조 w500
  static const double sm = 12.0;

  /// 문 보조 텍스트, 서브 설명 , 기본
  static const double md = 14.0;

  /// 16px — 기본 본문 텍스트, 기본 or 약간 강조 w500
  static const double base = 16.0;

  /// 18px — 카드 제목, 리스트 섹션 제목, w600
  static const double lg = 18.0;

  /// 20px — 화면 제목(AppBar), 큰 섹션 제목, w600 or w700
  static const double xl = 20.0;

  /// 24px — 홈 화면 헤더, 매우 큰 제목, w700
  static const double display = 24.0;
}
