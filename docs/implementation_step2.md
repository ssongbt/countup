# CountUp Implementation Plan (Step 2)

## 1) Finalized Data Model

### Goal
- `id: String`
- `title: String` (1..30)
- `targetCount: int` (1..9999)
- `currentCount: int` (0..targetCount)
- `status: GoalStatus`
- `createdAt: DateTime`
- `completedAt: DateTime?`
- `updatedAt: DateTime`
- `visualType: GoalVisualType`

### GoalStatus
- `active`
- `completed`
- `archived`

### GoalVisualType
- `dots`
- `blocks`
- `circle`

## 2) Folder Architecture (MVP)
- `lib/core/routing`
- `lib/features/goals/domain/entities`
- `lib/features/goals/domain/repositories`
- `lib/features/goals/presentation`

Notes:
- Keep domain layer independent from database package types.
- Add data layer in Step 3 (Isar schema + repository implementation).

## 3) Route Map (MVP)
- `/home`: Goal list
- `/create`: Goal create
- `/goal/:id`: Goal detail (+1 / undo)

## 4) File-by-File Task Breakdown (for next steps)
1. `lib/features/goals/domain/entities/goal.dart`
   - Entity + domain rules (`progress`, `remainingCount`, `isCompleted`)
2. `lib/core/routing/app_routes.dart`
   - Route path constants for all screens
3. `lib/features/goals/domain/repositories/goal_repository.dart`
   - Repository contract
4. Step 3+
   - Isar model + mapper + repository impl
   - Riverpod providers/notifiers
   - UI screens and widgets

## 5) Definition of Done (Step 2)
- [x] Goal fields and enums are finalized.
- [x] Route paths are finalized.
- [x] Initial architecture directories/files are prepared.
- [x] Next implementation order is documented.
