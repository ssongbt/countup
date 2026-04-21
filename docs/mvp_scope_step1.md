# CountUp MVP Scope (Step 1)

## 1) Goal
- Build a simple finite-goal counting app focused on completion feeling.
- Avoid complex task management in MVP.
- Deliver a stable offline-first Android MVP quickly.

## 2) In Scope (MVP)
- Create goal with `title` and `targetCount`.
- Show goal list cards with progress (`current/target`, percent, remaining count).
- Goal detail page with one-tap `+1`.
- One-step `undo` for the most recent increment action.
- Auto-complete goal when `currentCount >= targetCount`.
- Completion feedback (dialog or bottom sheet + lightweight animation).
- Persist data locally so progress remains after app restart.

## 3) Out of Scope (Not in MVP)
- History/log timeline and calendar.
- Cloud sync, login/account, multi-device sync.
- Social features (sharing, ranking, groups).
- Advanced analytics dashboard.
- Full reminder system (local notifications can be added later).

## 4) Completion Rules
- A goal is completed as soon as count reaches target.
- Completed goals are read-only for increment in MVP.
- Undo is limited to the last increment action only.
- Progress value is clamped between `0` and `targetCount`.

## 5) Primary User Flows
1. User creates a goal in under 3 seconds.
2. User opens goal detail and taps `+1` repeatedly.
3. User can undo the last tap once if it was accidental.
4. App shows completion feedback immediately on completion.
5. User returns to home and sees updated progress card.

## 6) MVP Quality Bar
- Offline operation for all MVP features.
- Action response feels immediate (target: under 100ms perceived for `+1`).
- No crash in core path: create -> increment -> complete -> reopen app.
- Input validation:
  - `title`: 1 to 30 chars
  - `targetCount`: 1 to 9999

## 7) Acceptance Checklist (Step 1 Baseline)
- [ ] In/Out scope is agreed.
- [ ] Completion and undo rules are agreed.
- [ ] Primary user flow is agreed.
- [ ] MVP quality bar is agreed.

## 8) Deferred to Step 2
- Data model finalization (`Goal` fields and status enum).
- Folder architecture and route map.
- Detailed task breakdown by files.
