# ESP32 Security App - Quick Start Guide

## 📋 Overview
The ESP32 Security App is a Flutter-based mobile application that connects to an ESP32 microcontroller via Bluetooth to monitor and alert on fire and magnetic intrusion detection events.

---

## 🚀 Quick Start (30 seconds)

### Step 1: Run the App
```bash
cd /home/ltgwgeorge/Desktop/projects/esp32_security_app
flutter run
```

### Step 2: Test the App
1. **Connect to ESP32**: Tap the blue "🔗 Connect to ESP32" button
2. **Select Device**: Choose your ESP32 from the list
3. **Test Sound**: Tap "🔊 Test Sounds" to verify audio works
4. **View Logs**: Tap "⚙️ Settings & Logs" to see emergency records
5. **Toggle Theme**: Use the theme button (☀️/🌙) in the top right

---

## 📖 Feature Guide

### Home Screen
- **🔒 Title Bar**: Shows app name with theme toggle and settings buttons
- **Connection Status**: Green dot = Connected, Red dot = Disconnected
- **Alert Display**: Shows current alert status (Fire/Magnet/Normal)
- **Commands Section**:
  - **🔗 Connect to ESP32**: Pairs with your Bluetooth device
  - **❌ Disconnect**: Disconnects from device
  - **🔊 Test Sounds**: Play test alerts to verify sound works
  - **⚙️ Settings & Logs**: View emergency logs and settings

### Settings Screen
- **Display Theme**: Toggle between light and dark mode (☀️/🌙)
- **Emergency Logs Section**:
  - View all recorded alerts with timestamps
  - Statistics: Total alerts, Fire alerts, Magnet alerts
  - 📥 **Export Logs**: Save all logs to console/file
  - 🗑️ **Clear All Logs**: Delete all records
- **About**: App version and build information

### Emergency Logs
- Each log shows:
  - Alert type (🔥 Fire or 🧲 Magnet)
  - Description of the alert
  - Timestamp (Date and Time)
- Logs are automatically saved when alerts trigger
- Sorted by newest first

---

## 🔊 Sound Testing

### To Test Sounds:
1. Open the app
2. Tap **"🔊 Test Sounds"** button
3. Select **"🔥 Test Fire Alert"** or **"🧲 Test Magnet Alert"**
4. Check that:
   - Sound plays from device speaker
   - Notification appears
   - Log is saved in Settings

### If Sound Doesn't Work:
1. Check device volume is not muted
2. Verify `assets/sounds/fire_alert.mp3` and `magnetic_alert.mp3` exist
3. Run with verbose logs: `flutter run -v`
4. Check console output for audio errors

---

## 🔌 Bluetooth Connection

### To Connect to ESP32:
1. First, **pair** the ESP32 in Android Settings → Bluetooth
2. In the app, tap **"🔗 Connect to ESP32"**
3. Select your device from the list
4. Status will show "Connected to [Device Name]"

### Connection Troubleshooting:
- Ensure Bluetooth is enabled on your phone
- Restart the app if connection fails
- Restart both phone and ESP32
- Toggle Bluetooth off/on on your phone

---

## 📊 Viewing Emergency Logs

### To View Logs:
1. Tap **"⚙️ Settings & Logs"** on home screen
2. Scroll to **"📋 Emergency Logs"** section
3. See summary cards at top:
   - Total Alerts (overall count)
   - 🔥 Fire (fire alerts only)
   - 🧲 Magnet (magnetic alerts only)
4. Scroll down to see detailed log list

### To Export Logs:
1. Go to Settings → Emergency Logs
2. Tap **"📥 Export Logs"** button
3. Logs are saved and printed to console
4. Data appears in format: `Exported Logs: [JSON data]`

### To Clear Logs:
1. Go to Settings → Emergency Logs
2. Tap **"🗑️ Clear All Logs"** button
3. Confirm deletion when prompted
4. All logs will be permanently deleted

---

## 🌓 Theme Toggle

### To Change Theme:
- **Option 1**: Tap the theme icon (☀️/🌙) in top right of any screen
- **Option 2**: Go to Settings → Display Theme → Toggle switch

### Current Status:
- 🌙 **Dark Mode**: Orange accents, dark background (default)
- ☀️ **Light Mode**: Orange accents, light background

Your theme preference is automatically saved.

---

## 📝 All Commands Reference

See **COMMANDS.md** in the project root for complete command reference including:
- Build commands (APK, AAB, iOS)
- Debug and run commands
- Code analysis and formatting
- Dependency management
- Troubleshooting

---

## 🛠️ Development Pipeline

See **PIPELINE.md** for detailed development workflow including:
- Environment setup steps
- Feature implementation phases
- Testing procedures
- Build and deployment instructions
- Issue tracking and fixes

---

## 🐛 Common Issues & Solutions

### Issue: App crashes on startup
**Solution**: 
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Sound not playing
**Solution**:
1. Check device volume (not muted)
2. Run with verbose: `flutter run -v`
3. Check debug console for audio errors
4. Verify audio files exist in `assets/sounds/`

### Issue: Can't find ESP32 device
**Solution**:
1. Pair device in Android Bluetooth settings first
2. Restart app
3. Restart phone Bluetooth
4. Restart ESP32 device

### Issue: Theme not saving
**Solution**:
```bash
flutter clean
flutter pub get
```

---

## 📱 Permissions Required

### Android (`AndroidManifest.xml`):
- `BLUETOOTH`
- `BLUETOOTH_ADMIN`
- `BLUETOOTH_CONNECT`
- `BLUETOOTH_SCAN`
- `RECORD_AUDIO`
- `MODIFY_AUDIO_SETTINGS`

### iOS (`Info.plist`):
- NSBluetoothCentralUsageDescription
- NSBluetoothPeripheralUsageDescription
- NSMicrophoneUsageDescription

---

## 📊 Project Statistics

- **Total Files**: 10+ Dart files
- **Dependencies**: 8 main packages
- **Supported Platforms**: Android, iOS
- **Min SDK**: API 21 (Android 5.0)
- **Flutter Version**: 3.9.2+

---

## 🔗 Useful Links

- **Flutter Docs**: https://flutter.dev
- **Bluetooth Plugin**: https://pub.dev/packages/flutter_bluetooth_serial
- **Audio Player**: https://pub.dev/packages/audioplayers
- **Provider State Management**: https://pub.dev/packages/provider
- **Shared Preferences**: https://pub.dev/packages/shared_preferences

---

## ✅ Testing Checklist

Before deploying, verify:
- [ ] App starts without crashes
- [ ] Bluetooth connection works
- [ ] Fire alert sound plays
- [ ] Magnet alert sound plays
- [ ] Notifications appear
- [ ] Emergency logs save with timestamps
- [ ] Logs can be viewed in Settings
- [ ] Logs can be cleared
- [ ] Theme toggle works
- [ ] Theme preference persists after restart
- [ ] All buttons are labeled clearly
- [ ] UI is responsive on all screen sizes

---

## 🚀 Next Steps

1. **Run the app**: `flutter run`
2. **Test features**: Follow Feature Guide above
3. **Connect to ESP32**: Use Bluetooth connection button
4. **Monitor logs**: Check Settings for alert records
5. **Report issues**: Check console output with `flutter run -v`

---

## 📞 Support

For detailed information:
- See **COMMANDS.md** for command reference
- See **PIPELINE.md** for development workflow
- Check console output: `flutter run -v`
- Review code comments in `lib/` folder

---

## 📄 File Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── home_screen.dart     # Main UI with commands
│   └── settings_screen.dart # Settings & logs viewer
├── services/
│   └── bluetooth_service.dart
├── utils/
│   ├── sound_player.dart    # Audio playback
│   ├── storage_service.dart # Emergency logs storage
│   └── theme_provider.dart  # Theme management
└── theme/
    └── app_theme.dart       # Theme definitions
```

---

## 🎯 Key Features

✅ Bluetooth connectivity to ESP32  
✅ Real-time fire and magnet alerts  
✅ Sound notifications (with volume control)  
✅ Emergency event logging with timestamps  
✅ Log export and clearing functionality  
✅ Light/Dark theme toggle  
✅ Persistent theme preference  
✅ Clear, labeled UI commands  
✅ Comprehensive error handling  
✅ Production-ready code quality  

---

**Version**: 1.0.0  
**Last Updated**: October 16, 2025  
**Status**: ✅ Ready for Testing
