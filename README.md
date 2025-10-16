# ESP32 Security App

A comprehensive Flutter application for real-time security monitoring with Bluetooth connectivity to ESP32 sensors. Includes fire detection, magnetic field monitoring, dark/light themes, emergency logging, and audio alerts.

## 🚀 Quick Start Commands

### **Development Setup**
```bash
# Get Flutter dependencies
flutter pub get

# Analyze code for errors
flutter analyze

# Clean build artifacts
flutter clean
```

### **Running the App**
```bash
# Run on connected Android device in debug mode
flutter run

# Run in release mode (optimized, faster)
flutter run --release

# Run on specific device
flutter devices  # List connected devices
flutter run -d <device_id>
```

### **Building APK**
```bash
# Build debug APK
flutter build apk --debug

# Build release APK (for distribution)
flutter build apk --release
```

### **Development & Testing**
```bash
# Hot reload (updates code without restarting app)
# In flutter run terminal, press 'r'

# Hot restart (full app restart)
# In flutter run terminal, press 'R'

# Run unit/widget tests
flutter test

# Get test coverage
flutter test --coverage
```

---

## 📋 Features

✅ **Bluetooth Connectivity**
- Automatic device discovery and pairing
- Real-time sensor data streaming
- Reliable connection management

✅ **Security Alerts**
- 🔥 Fire Detection with audio alert
- 🧲 Magnetic Field Monitoring with notification
- Instant system notifications
- Maximum volume audio playback on speaker

✅ **User Interface**
- Dark/Light mode toggle
- Emergency log storage with timestamps
- Clear emergency logs button
- Obvious, color-coded buttons for all commands

✅ **Emergency Logging**
- Automatic timestamp recording
- Alert type and sensor values stored
- Persistent local storage
- View/Clear logs from settings page

---

## 📱 How to Use the App

### **Connecting to ESP32**
1. **Open the App** - Tap "Connect" button (Bluetooth icon)
2. **Select Device** - Choose your ESP32 device from the list
3. **Monitor** - Watch the status and alert indicators in real-time

### **Viewing Settings & Logs**
1. **Tap Settings** (gear icon) in top-right corner
2. **View Logs** - All emergency events with timestamps
3. **Change Theme** - Toggle Dark/Light mode
4. **Clear Logs** - Remove all stored emergency records

### **Understanding Alerts**
- 🔥 **Fire Alert** - Red icon appears, audio plays, notification shows
- 🧲 **Magnetic Alert** - Blue icon appears, audio plays, notification shows
- ✅ **Normal** - Green checkmark, systems operating normally

---

## 🔧 Android Build Configuration

The app uses Java 8 desugaring for compatibility:
```gradle
android {
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
    
    dependencies {
        coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.4'
    }
}
```

---

## 🔐 Permissions

The app requires these Android permissions:
- `BLUETOOTH_CONNECT` - Connect to paired devices
- `BLUETOOTH_SCAN` - Discover Bluetooth devices  
- `POST_NOTIFICATIONS` - Show system notifications
- `RECORD_AUDIO` - Audio playback through speakers

All permissions are requested at runtime.

---

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── home_screen.dart      # Main monitoring screen
│   └── settings_screen.dart  # Settings & logs page
├── services/
│   └── bluetooth_service.dart # Bluetooth connectivity
├── utils/
│   ├── sound_player.dart     # Audio alerts & notifications
│   ├── storage_service.dart  # Emergency log storage
│   └── theme_provider.dart   # Theme management
└── theme/
    └── app_theme.dart        # UI theme definitions
```

---

## 🐛 Troubleshooting

### **Sounds don't play**
- Ensure device volume is up
- Check that device is not in silent mode
- Open Settings → Audio Context and verify speaker routing
- Try disconnecting and reconnecting the Bluetooth device

### **Bluetooth won't connect**
- Ensure ESP32 is paired in Android Settings → Bluetooth
- Turn Bluetooth off and on again
- Check app has location permissions (required for Bluetooth scanning)
- Verify ESP32 is powered on and in range

### **App crashes on startup**
- Run `flutter clean` to clear build cache
- Run `flutter pub get` to reinstall dependencies
- Check logs: `flutter logs`

---

## 🛠️ Useful Commands Cheat Sheet

| Task | Command |
|------|---------|
| Check for errors | `flutter analyze` |
| Run on device | `flutter run` |
| Clean project | `flutter clean` |
| Get dependencies | `flutter pub get` |
| Build APK | `flutter build apk --release` |
| View logs | `flutter logs` |
| List devices | `flutter devices` |
| Run tests | `flutter test` |
| Format code | `dart format lib/` |
| Fix common issues | `dart fix --apply` |

---

## 📞 Support

For issues or questions:
1. Check the troubleshooting section above
2. Run `flutter doctor` to diagnose environment issues
3. Review `flutter logs` for detailed error messages
