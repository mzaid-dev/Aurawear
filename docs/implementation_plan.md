# Project Cleanup and Refactoring Plan

## Goal Description
The goal is to clean up the project by removing extra/duplicate files, renaming files with generic names to be more descriptive, and ensuring a professional code structure.
**Update:** Overhauled project documentation (`README.md`) to be professional and high-end.

## User Review Required
> [!WARNING]
> I will be deleting `lib/features/onboarding/presentation/view/splash_screen.dart` if it exists, as it appears to be a duplicate of the splash screen in `lib/features/splash`.

## Proposed Changes

### Documentation
#### [MODIFY] [README.md](file:///c:/Users/suleh/Desktop/project/Aurawear/README.md)
- Added professional banner (`aurawear_banner_mockup.png`).
- Rewrote sections: Overview, Features, Tech Stack, Installation.
- Added screenshot placeholders.

### Cleanup
#### [DELETE] [splash_screen.dart](file:///c:/Users/suleh/Desktop/project/Aurawear/lib/features/onboarding/presentation/view/splash_screen.dart)
- This file seems to be a duplicate or misplaced. The actual splash screen is in `features/splash`.

### Refactoring
#### [MODIFY] `lib/features/onboarding/presentation/pages/`
- Rename `screen1.dart` -> `onboarding_page_one.dart`
- Rename `screen2.dart` -> `onboarding_page_two.dart`
- Rename `screen3.dart` -> `onboarding_page_three.dart`
- Update class names `Screen1` -> `OnboardingPageOne`, etc.
- Update references in `app_router.dart` (or wherever they are used).

### Code Quality
- Check `splash_screen.dart` (the correct one) and extract `_Particle` classes if they are cluttering the file.
- Review `product_details_page.dart` for any minor cleanups (e.g., removing `print` if any found manually, though analyze didn't find any).

## Verification Plan
### Automated Tests
- Run `flutter analyze` to ensure no broken imports after renaming/deleting.
- Run `flutter test` (if tests exist).

### Manual Verification
- Launch the app.
- Verify Splash Screen loads correctly (from `features/splash`).
- Verify navigation to Onboarding.
- Verify Onboarding pages 1, 2, 3 display correctly.
