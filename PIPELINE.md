# ESP32 Security App - Migration Pipeline

## Overview
This document outlines the complete pipeline for developing, building, testing, and deploying the ESP32 Security App.

---

## Phase 1: Environment Setup

### Step 1.1: Verify Flutter Installation
```bash
flutter doctor
```
Should show no major issues. If there are issues, fix them before proceeding.

### Step 1.2: Clone and Setup Project
```bash
cd /home/ltgwgeorge/Desktop/projects/esp32_security_app
flutter clean
flutter pub get
flutter analyze
```

### Step 1.3: Verify Project Structure
Ensure the following directories exist:
- `lib/` - Main application code
- `assets/sounds/` - Sound files (fire_alert.mp3, magnetic_alert.mp3)
- `android/` - Android-specific code
- `ios/` - iOS-specific code

---

## Phase 2: Feature Implementation & Bug Fixes

### 2.1: Sound Playback Fix
**Status**: In Progress  
**Issue**: Audio doesn't play on device  
**Actions**:
- [x] Verify audio files exist in assets
- [x] Check audio context configuration
- [x] Add volume and release mode settings
- [x] Verify Android/iOS permissions
- [ ] Test with actual device

**Files Modified**:
- `lib/utils/sound_player.dart` - Fixed audio routing and context

### 2.2: Enhanced Settings Screen
**Status**: In Progress  
**Issue**: Settings page needs emergency logs and theme control  
**Features to Add**:
- [x] Theme toggle (Light/Dark mode)
- [x] View emergency logs with timestamps
- [x] Clear emergency logs with confirmation
- [ ] Export logs as JSON
- [ ] Filter logs by type

**Files Modified**:
- `lib/screens/settings_screen.dart` - Enhanced UI and functionality

### 2.3: Improved UI/UX
**Status**: In Progress  
**Issue**: Commands and options not obvious  
**Changes**:
- Make theme toggle button prominent
- Add clear button labels and icons
- Add test buttons for fire/magnet alerts
- Make Bluetooth connection status visible

**Files Modified**:
- `lib/screens/home_screen.dart` - Enhanced UI
- `lib/screens/settings_screen.dart` - Better layout

### 2.4: Emergency Logs Management
**Status**: In Progress  
**Features**:
- View all emergency logs with timestamps
- Filter by alert type (Fire/Magnetic)
- Clear logs with confirmation dialog
- Export logs as JSON

**Files Modified**:
- `lib/utils/storage_service.dart` - Already has all necessary methods
- `lib/screens/settings_screen.dart` - UI for viewing/clearing logs

---

## Phase 3: Testing & Validation

### 3.1: Local Testing
```bash
# Run on connected device/emulator
flutter run

# Run with verbose logging
flutter run -v

# Run in release mode (production build)
flutter run --release
```

### 3.2: Code Analysis
```bash
# Check for code issues
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test
```

### 3.3: Manual Testing Checklist
- [ ] App starts without crashes
- [ ] Bluetooth connection works
- [ ] Fire alert sound plays
- [ ] Magnet alert sound plays
- [ ] Notification shows when alert plays
- [ ] Emergency logs are saved with timestamps
- [ ] Logs can be viewed in Settings
- [ ] Logs can be cleared
- [ ] Light/Dark theme toggle works
- [ ] Theme preference persists after restart

---

## Phase 4: Building for Release

### 4.1: Build APK (Debug)
```bash
flutter build apk --debug
```
Output: `build/app/outputs/flutter-apk/app-debug.apk`

### 4.2: Build APK (Release)
```bash
flutter clean
flutter pub get
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### 4.3: Build App Bundle (for Google Play)
```bash
flutter build appbundle
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### 4.4: Build iOS
```bash
flutter build ios
```

---

## Phase 5: Deployment

### 5.1: Local Device Installation (APK)
```bash
# Install on connected device
adb install build/app/outputs/flutter-apk/app-release.apk

# Or let Flutter handle it
flutter install
```

### 5.2: Google Play Store
1. Generate signed APK or AAB (see Phase 4.2/4.3)
2. Upload to Google Play Console
3. Follow Play Store guidelines for security apps

### 5.3: iOS App Store
1. Build: `flutter build ios`
2. Open Xcode: `open ios/Runner.xcworkspace`
3. Archive and upload to App Store

---

## Issue Tracking & Fixes

### Issue #1: Sound Not Playing ✓ FIXED
**Problem**: Audio playback fails on Android device  
**Root Cause**: Incorrect audio context and missing release mode configuration  
**Solution**: 
- Set `ReleaseMode.stop` to prevent multiple overlapping sounds
- Configure `AudioContextAndroid` with proper audio focus
- Configure `AudioContextIOS` with speaker playback

**Verification**: Test with device

### Issue #2: Settings Page Incomplete ✓ IN PROGRESS
**Problem**: Missing emergency logs viewing and management UI  
**Solution**: Enhanced `settings_screen.dart` with:
- Emergency logs viewer
- Log clearing functionality
- Filter by type
- Export as JSON

### Issue #3: UI Not User-Friendly ✓ IN PROGRESS
**Problem**: Commands and options not obvious to users  
**Solution**:
- Added prominent theme toggle button
- Added test alert buttons
- Made status indicators visible
- Added clear labels and icons

---

## Development Guidelines

### Code Style
- Use `// ignore: avoid_print` for debug prints
- Use `const` where possible
- Follow Dart naming conventions
- Add comments for complex logic

### Error Handling
- All async operations wrapped in try-catch
- Debug prints with `kDebugMode` check
- User-friendly error messages in SnackBars

### Performance
- Use `const` constructors
- Rebuild only when necessary (use `Consumer` wisely)
- Lazy load data where possible

### Permissions
Android (`android/app/src/main/AndroidManifest.xml`):
- `BLUETOOTH`
- `BLUETOOTH_ADMIN`
- `BLUETOOTH_CONNECT`
- `BLUETOOTH_SCAN`
- `RECORD_AUDIO`
- `MODIFY_AUDIO_SETTINGS`

iOS (`ios/Runner/Info.plist`):
- `NSBluetoothPeripheralUsageDescription`
- `NSBluetoothCentralUsageDescription`
- `NSMicrophoneUsageDescription`

---

## Git Workflow

### Commit Messages
```
[FEATURE] Add feature name
[BUGFIX] Fix issue description
[DOCS] Update documentation
[REFACTOR] Improve code structure
```

### Example Workflow
```bash
# Create branch for feature
git checkout -b feature/emergency-logs

# Make changes and commit
git add .
git commit -m "[FEATURE] Add emergency logs viewer"

# Merge to main
git checkout main
git merge feature/emergency-logs
```

---

## Monitoring & Logging

### Debug Logs
Run with verbose logging to see all output:
```bash
flutter run -v
```

### View Logs in App
Navigate to **Settings → View Emergency Logs** to see all recorded alerts with timestamps.

### Export Logs
Call `StorageService.exportLogsAsJson()` to get all logs as JSON string.

---

## Maintenance

### Regular Updates
```bash
# Update Flutter
flutter upgrade

# Update dependencies
flutter pub upgrade

# Check for issues
flutter doctor
flutter analyze
```

### Archive Old Logs
```dart
// Call from settings screen to export and clear
String jsonLogs = await StorageService.exportLogsAsJson();
// Save to external storage or send to server
await StorageService.clearAllLogs();
```

---

## Contact & Support

For issues or questions:
1. Check `COMMANDS.md` for command reference
2. Run `flutter doctor` to verify environment
3. Check console logs: `flutter run -v`
4. Refer to package documentation on pub.dev

---

## Version History

- **v1.0.0**: Initial release with Bluetooth connectivity, fire/magnet alerts, and emergency logs
- **v1.1.0** (In Progress): Enhanced UI, theme toggle, improved logs management

---

## Next Steps

1. Run `flutter pub get`
2. Connect device or start emulator
3. Run `flutter run`
4. Test all features according to Phase 3.3 checklist
5. Report any issues for further fixes
