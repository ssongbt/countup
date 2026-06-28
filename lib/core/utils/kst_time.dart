/// 기기의 시간대 설정과 무관하게 한국 표준시(KST, UTC+9)를 반환합니다.
DateTime kstNow() => DateTime.now().toUtc().add(const Duration(hours: 9));
