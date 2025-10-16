# ESP32 Security App - Command Guide

## Essential Commands

### 1. **Clean the Project**
```bash
flutter clean
```
Use this when you encounter build errors or want a fresh build.

---

### 2. **Get Dependencies**
```bash
flutter pub get
```
Run this after cloning the project or after modifying `pubspec.yaml`.

---

### 3. **Analyze Code**
```bash
flutter analyze
```
Checks for code issues, linting errors, and best practices.

---

### 4. **Run the App**

#### On a Connected Device or Emulator:
```bash
flutter run
```

#### Run in Debug Mode (Verbose):
```bash
flutter run -v
```

#### Run in Release Mode (Optimized):
```bash
flutter run --release
```

#### Run on a Specific Device:
```bash
flutter run -d <device_id>
```

#### List Available Devices:
```bash
flutter devices
```

---

### 5. **Build APK (Android Release Build)**
```bash
flutter build apk
```
Creates an APK file at: `build/app/outputs/flutter-apk/app-release.apk`

---

### 6. **Build APK (Android Debug Build)**
```bash
flutter build apk --debug
```

---

### 7. **Build AAB (Android App Bundle)**
```bash
flutter build appbundle
```
Required for Google Play Store distribution.

---

### 8. **Build iOS App**
```bash
flutter build ios
```

---

### 9. **Format Code**
```bash
dart format lib/
```
Auto-formats all Dart files in the `lib` folder.

---

### 10. **Run Tests**
```bash
flutter test
```
Executes all unit tests in the `test/` folder.

---

### 11. **Update Dependencies**
```bash
flutter pub upgrade
```
Updates all dependencies to their latest versions.

---

### 12. **Get Doctor Info**
```bash
flutter doctor
```
Checks your Flutter environment for any issues.

---

### 13. **Enable Bluetooth Logging** (Debug Mode)
```bash
flutter run -v
```
This shows detailed logs including Bluetooth communications.

---

### 14. **Hot Reload During Development**
Press `R` in the terminal after running `flutter run`.

---

### 15. **Hot Restart (Full App Restart)**
Press `Shift + R` in the terminal after running `flutter run`.

---

## Troubleshooting Commands

### Reset Gradle Cache
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Rebuild Native Code
```bash
flutter clean
flutter pub get
flutter run
```

### Fix Permission Issues (Linux/macOS)
```bash
chmod +x android/gradlew
```

---

## Development Workflow

### Quick Development Flow:
1. **Start Development**: `flutter run`
2. **Make Changes**: Edit your code
3. **Hot Reload**: Press `R` in terminal
4. **Repeat steps 2-3** as needed
5. **Full Restart if needed**: Press `Shift + R`

### Before Submitting Code:
```bash
flutter analyze
dart format lib/
flutter test
flutter run --release
```

---

## Additional Resources

- **Official Flutter Docs**: https://flutter.dev/docs
- **Bluetooth Plugin Docs**: https://pub.dev/packages/flutter_bluetooth_serial
- **Audio Player Docs**: https://pub.dev/packages/audioplayers

---

## App-Specific Commands

### Testing Fire Alert Sound
1. Connect to ESP32 device via Bluetooth
2. Navigate to **Home Screen**
3. Tap the **"Test Fire Alert"** button
4. Check logs in **Settings → View Emergency Logs**

### Testing Magnetic Alert Sound
1. Connect to ESP32 device via Bluetooth
2. Navigate to **Home Screen**
3. Tap the **"Test Magnetic Alert"** button
4. Check logs in **Settings → View Emergency Logs**

### Clear Emergency Logs
1. Go to **Settings**
2. Tap **"Emergency Logs"**
3. Tap **"Clear All Logs"** button
4. Confirm deletion

---

## Common Issues & Solutions

### App Crashes on Startup
- Run `flutter clean && flutter pub get`
- Ensure all permissions are granted in Android Settings
- Check console output: `flutter run -v`

### Sound Not Playing
- Verify audio files exist in `assets/sounds/`
- Check Android permissions in `AndroidManifest.xml`
- Test with `flutter run -v` to see debug logs
- Check volume is not muted on the device

### Bluetooth Connection Issues
- Ensure Bluetooth is enabled on the device
- Pair ESP32 device in Android Settings first
- Restart the app
- Restart the Bluetooth service: Toggle Bluetooth off/on

### Build Errors
- Run `flutter doctor` to check environment
- Update Flutter: `flutter upgrade`
- Clean everything: `flutter clean`
- Get dependencies: `flutter pub get`
