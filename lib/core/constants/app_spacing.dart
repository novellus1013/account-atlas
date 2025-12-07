class AppSpacing {
  const AppSpacing._();

  //아이콘과 텍스트 사이 같이 아주 작은 틈만 띄우는 용도
  static const double xs = 4.0;

  //작은 아이콘 여러개, 카테고리 혹은 태그 같은 칩들의 나열, 폼에서 작은 요소들 사이의 간격
  static const double sm = 8.0;

  //기본 간격 - 제목과 부제 사이, 리스트 아이템 내부 요소 사이, 버튼들과 설명 텍스트 사이 등
  //일단 md 써보고 간격 조절을 해보자
  static const double md = 12.0;

  //화면 좌우 패딩, 카드 또는 박스 내부 패딩,
  static const double basic = 16.0;

  //큰 섹션 (UI 블록) 사이의 간격
  static const double lg = 24.0;

  //화면 상단 하단에  큰 간격, scrollview 상단 하단 큰간격, 빈 상태를 안내하는 화면에서 상단 하단 큰 간격
  static const double xl = 32.0;
}
