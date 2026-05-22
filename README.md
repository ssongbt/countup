# CountUp

**끝이 있는 목표**를 횟수로 세고, 완료감을 빠르게 느끼게 하는 유한 목표 카운터 앱입니다.  
할 일 관리가 아니라 **「N번 하면 끝」**인 개인 목표(예: 헬스 13번, 책 30권)에 집중합니다.

- 오프라인 우선 · 로컬 저장(Hive)
- 탭 한 번으로 +1, 진행률 즉시 반영
- Flutter · Android MVP 우선 (iOS/Web/Desktop 스캐폴딩 포함)

---

## 핵심 기능

| 화면 | 기능 |
|------|------|
| **홈** | 목표 목록(진행률 %, `current/target`, 프로그레스 바), 진행 중 목표 우선 정렬, FAB로 생성 |
| **목표 생성** | 제목(최대 30자), 목표 횟수(1~999) |
| **목표 상세** | +1(중앙 탭 또는 버튼), 남은 횟수, 1회 undo, 완료 시 다이얼로그, 삭제 |

### 비즈니스 규칙

- `currentCount`는 `0` ~ `targetCount`로 제한
- 목표 횟수에 도달하면 자동 완료(`status: completed`, `completedAt` 기록)
- 완료된 목표는 +1 불가
- **Undo**는 직전 +1 **1회만** 가능(앱 세션 내, 마지막으로 증가한 목표에 한함)
- Undo 시 완료 상태가 해제되고 다시 진행 가능

---

## 기술 스택

| 영역 | 라이브러리 |
|------|------------|
| UI | Flutter (Material 3) |
| 상태 관리 | [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) |
| 라우팅 | [go_router](https://pub.dev/packages/go_router) |
| 로컬 DB | [hive](https://pub.dev/packages/hive) / [hive_flutter](https://pub.dev/packages/hive_flutter) |
| 기타 | uuid, intl, path_provider |

---

## 프로젝트 구조

```
lib/
├── main.dart                      # 앱 진입, 테마, DB 초기화 게이트
├── core/
│   ├── db/hive_provider.dart      # Hive box (`goals_box`)
│   └── routing/                   # app_router, app_routes
└── features/goals/
    ├── domain/                    # Goal 엔티티, GoalRepository 인터페이스
    ├── data/                      # GoalModel, HiveGoalRepository
    └── presentation/              # Riverpod providers, 화면
```

### 라우트

| 경로 | 화면 |
|------|------|
| `/home` | 목표 목록 |
| `/create` | 목표 생성 |
| `/goal/:id` | 목표 상세 |

---

## 데이터 모델

`Goal` 엔티티 필드:

| 필드 | 설명 |
|------|------|
| `id` | UUID |
| `title` | 목표 이름 |
| `targetCount` | 목표 횟수 |
| `currentCount` | 현재 횟수 |
| `status` | `active` · `completed` · `archived`(예약) |
| `createdAt` / `updatedAt` | 생성·수정 시각 |
| `completedAt` | 완료 시각(완료 시) |
| `visualType` | `dots` · `blocks` · `circle`(예약, 현재 항상 `dots`) |

파생 값: `progress`, `remainingCount`, `isCompleted`

---

## 시작하기

### 요구 사항

- Flutter SDK `^3.11.4` (see `pubspec.yaml`)
- Android 개발 환경(에뮬레이터 또는 실기기)

### 실행

```bash
flutter pub get
flutter run
```

### 테스트

```bash
flutter test
```

---

## 디자인

- 폰트: **Pretendard** (Regular / Medium / Bold)
- Primary `#5C6FA3`, Secondary `#5F8F8B`, Surface `#F4F6F8`

---

## MVP 범위

### 구현됨

- 목표 생성 · 목록 · 상세 · 삭제
- +1, 완료 처리, 완료 알림(다이얼로그)
- 1회 undo, 로컬 영속화

### 예약 / 부분 구현

- `GoalVisualType` 시각화 UI
- `archived` 상태(보관)
- 완료 축하 애니메이션(`confetti` 등은 `pubspec.yaml` 주석 처리)

### 범위 밖

- 히스토리·캘린더, 클라우드·계정, 소셜, 분석 대시보드, 알림

상세 MVP 정의는 [`docs/mvp_scope_step1.md`](docs/mvp_scope_step1.md)를 참고하세요.

---

## 로드맵 (요약)

1. **MVP 마무리** — 완료 UX 강화, 홈 카드 정보 보강, 검증 규칙 정리
2. **목표 생명주기** — 수정, `archived` 보관, undo 정책(세션 vs 영속) 결정
3. **차별화** — `visualType` UI, 완료 통계, 로컬 알림(선택)
4. **확장** — 클라우드 백업, 계정, 공유

---

## 라이선스

프로젝트 루트 및 `assets/fonts/pretendard-release/LICENSE.txt`의 Pretendard 라이선스를 따릅니다.
