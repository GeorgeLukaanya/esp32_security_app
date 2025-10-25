# 🔒 ESP32 Security App# ESP32 Security App



## 📱 What This Project DoesA comprehensive Flutter application for real-time security monitoring with Bluetooth connectivity to ESP32 sensors. Includes fire detection, magnetic field monitoring, dark/light themes, emergency logging, and audio alerts.



This is a **Flutter mobile application** that monitors a security system connected via **Bluetooth to an ESP32 microcontroller**. The app detects and alerts users to two types of threats:## 🚀 Quick Start Commands



- **🔥 Fire Alerts** - Detects temperature/fire anomalies### **Development Setup**

- **🧲 Magnetic Field Alerts** - Detects unauthorized metallic intrusions```bash

# Get Flutter dependencies

### **Key Features:**flutter pub get



✅ **Real-Time Monitoring** - Live Bluetooth connection to ESP32  # Analyze code for errors

✅ **Dual Alert System** - Fire and Magnetic field detection  flutter analyze

✅ **Audio & Visual Alerts** - Sound notifications + LED indicators  

✅ **Emergency Logging** - All alerts automatically recorded with timestamps  # Clean build artifacts

✅ **Analytics Dashboard** - Timeline graphs and risk assessment  flutter clean

✅ **Dark/Light Theme** - Customizable UI appearance  ```

✅ **Remote Commands** - Send control commands to ESP32 via Bluetooth  

### **Running the App**

---```bash

# Run on connected Android device in debug mode

## 🎯 How It Worksflutter run



### **System Architecture:**# Run in release mode (optimized, faster)

flutter run --release

```

┌─────────────┐# Run on specific device

│   ESP32     │flutter devices  # List connected devices

│ Micro-      │flutter run -d <device_id>

│ controller  │```

│             │

│ • Temperature Sensor### **Building APK**

│ • Magnetic Sensor```bash

│ • Buzzer# Build debug APK

│ • LEDsflutter build apk --debug

└─────────┬───┘

          │ Bluetooth# Build release APK (for distribution)

          │ Serialflutter build apk --release

          ▼```

┌─────────────────────────────┐

│   Flutter Mobile App        │### **Development & Testing**

│                             │```bash

│ • Home Screen               │# Hot reload (updates code without restarting app)

│ • Settings & Logs           │# In flutter run terminal, press 'r'

│ • Analytics Dashboard       │

│ • Device Controls           │# Hot restart (full app restart)

└─────────────────────────────┘# In flutter run terminal, press 'R'

```

# Run unit/widget tests

### **Alert Flow:**flutter test



1. **ESP32 Detects Issue** - Temperature spike or magnetic field change# Get test coverage

2. **ESP32 Sends Alert** - "FIRE" or "MAGNET" message via Bluetoothflutter test --coverage

3. **App Receives Message** - Listens on Bluetooth connection```

4. **App Triggers Alert**:

   - Plays audio alert sound---

   - Shows visual notification

   - Records emergency log## 📋 Features

   - Updates UI with alert status

5. **User Can Respond** - Tap "Silence" to acknowledge alert✅ **Bluetooth Connectivity**

6. **User Investigates** - Check analytics for patterns- Automatic device discovery and pairing

- Real-time sensor data streaming

### **Control Flow:**- Reliable connection management



User taps button in app → App sends command → ESP32 receives command → ESP32 executes action✅ **Security Alerts**

- 🔥 Fire Detection with audio alert

**Available Commands:**- 🧲 Magnetic Field Monitoring with notification

- `ack` - Silence alert- Instant system notifications

- `status` - Get device status- Maximum volume audio playback on speaker

- `cal` - Calibrate sensors

- `reset` - Reset system✅ **User Interface**

- Dark/Light mode toggle

---- Emergency log storage with timestamps

- Clear emergency logs button

## 🚀 Setup Instructions- Obvious, color-coded buttons for all commands



### **Prerequisites:**✅ **Emergency Logging**

- Automatic timestamp recording

Before you start, ensure you have:- Alert type and sensor values stored

- Persistent local storage

1. **Flutter SDK** installed ([Download](https://flutter.dev))- View/Clear logs from settings page

   ```bash

   flutter --version  # Should show version info---

   ```

## 📱 How to Use the App

2. **Android SDK** (for Android development)

   ```bash### **Connecting to ESP32**

   flutter doctor  # Check setup1. **Open the App** - Tap "Connect" button (Bluetooth icon)

   ```2. **Select Device** - Choose your ESP32 device from the list

3. **Monitor** - Watch the status and alert indicators in real-time

3. **An ESP32 Device** paired via Bluetooth with your Android phone

   - Go to **Android Settings → Bluetooth** to pair first### **Viewing Settings & Logs**

   - Device name typically: `ESP32` or `esp32-security`1. **Tap Settings** (gear icon) in top-right corner

2. **View Logs** - All emergency events with timestamps

4. **Git** installed (for version control)3. **Change Theme** - Toggle Dark/Light mode

4. **Clear Logs** - Remove all stored emergency records

### **Step 1: Clone the Project**

### **Understanding Alerts**

```bash- 🔥 **Fire Alert** - Red icon appears, audio plays, notification shows

git clone https://github.com/GeorgeLukaanya/esp32_security_app.git- 🧲 **Magnetic Alert** - Blue icon appears, audio plays, notification shows

cd esp32_security_app- ✅ **Normal** - Green checkmark, systems operating normally

```

---

### **Step 2: Get Dependencies**

## 🔧 Android Build Configuration

```bash

flutter pub getThe app uses Java 8 desugaring for compatibility:

``````gradle

android {

This downloads all required packages:    compileOptions {

- `flutter_bluetooth_serial` - Bluetooth connectivity        sourceCompatibility JavaVersion.VERSION_1_8

- `audioplayers` - Sound playback        targetCompatibility JavaVersion.VERSION_1_8

- `fl_chart` - Analytics graphs    }

- `provider` - State management    

- `flutter_local_notifications` - System notifications    dependencies {

        coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.4'

### **Step 3: Connect Android Device or Start Emulator**    }

}

**Option A: Physical Device**```

```bash

# Enable USB Debugging on your phone---

# Connect via USB cable

flutter devices  # Should list your device## 🔐 Permissions

```

The app requires these Android permissions:

**Option B: Android Emulator**- `BLUETOOTH_CONNECT` - Connect to paired devices

```bash- `BLUETOOTH_SCAN` - Discover Bluetooth devices  

# Start emulator from Android Studio or:- `POST_NOTIFICATIONS` - Show system notifications

emulator -avd <emulator_name>- `RECORD_AUDIO` - Audio playback through speakers

flutter devices  # Should list emulator

```All permissions are requested at runtime.



### **Step 4: Run the App**---



```bash## 📁 Project Structure

flutter run

``````

lib/

First run will compile and install (~2-3 minutes).├── main.dart                 # App entry point

├── screens/

### **Step 5: Grant Permissions**│   ├── home_screen.dart      # Main monitoring screen

│   └── settings_screen.dart  # Settings & logs page

When app opens, grant permissions:├── services/

- ✅ Bluetooth Connect│   └── bluetooth_service.dart # Bluetooth connectivity

- ✅ Bluetooth Scan├── utils/

- ✅ Notifications│   ├── sound_player.dart     # Audio alerts & notifications

│   ├── storage_service.dart  # Emergency log storage

### **Step 6: Connect to ESP32**│   └── theme_provider.dart   # Theme management

└── theme/

In the app:    └── app_theme.dart        # UI theme definitions

1. Tap **"🔗 Connect to ESP32"** button```

2. Select your device from the list

3. Wait for connection confirmation---

4. Status should show "✅ Connected"

## 🐛 Troubleshooting

---

### **Sounds don't play**

## 📱 Using the App- Ensure device volume is up

- Check that device is not in silent mode

### **Home Screen**- Open Settings → Audio Context and verify speaker routing

- Try disconnecting and reconnecting the Bluetooth device

**Connection Status:**

- 🟢 Green dot = Connected to ESP32### **Bluetooth won't connect**

- 🔴 Red dot = Not connected- Ensure ESP32 is paired in Android Settings → Bluetooth

- Turn Bluetooth off and on again

**Commands Available (when connected):**- Check app has location permissions (required for Bluetooth scanning)

- 🔇 **Silence** - Stop active alert- Verify ESP32 is powered on and in range

- ℹ️ **Status** - Get device info

- 🔧 **Calibrate** - Recalibrate sensors### **App crashes on startup**

- ↻ **Reset** - Reset system- Run `flutter clean` to clear build cache

- Run `flutter pub get` to reinstall dependencies

**Other Buttons:**- Check logs: `flutter logs`

- 🔊 **Test Sounds** - Play fire/magnet alert sounds

- ⚙️ **Settings & Logs** - View logs and settings---



### **Settings Screen**## 🛠️ Useful Commands Cheat Sheet



**Theme Toggle:**| Task | Command |

- 🌙/☀️ Switch between Dark and Light mode|------|---------|

| Check for errors | `flutter analyze` |

**Emergency Logs:**| Run on device | `flutter run` |

- View all recorded alerts| Clean project | `flutter clean` |

- See fire vs magnetic breakdown| Get dependencies | `flutter pub get` |

- 📥 Export logs as JSON| Build APK | `flutter build apk --release` |

- 🗑️ Clear all logs| View logs | `flutter logs` |

| List devices | `flutter devices` |

**Analytics & Insights:**| Run tests | `flutter test` |

- 📊 View timeline graphs| Format code | `dart format lib/` |

- 📈 See daily/weekly/monthly statistics| Fix common issues | `dart fix --apply` |

- 🎯 Risk level assessment

- ⏰ Peak alert time identification---



---## 📞 Support



## 🔧 DevelopmentFor issues or questions:

1. Check the troubleshooting section above

### **Project Structure**2. Run `flutter doctor` to diagnose environment issues

3. Review `flutter logs` for detailed error messages

```
lib/
├── main.dart                    # App entry point
├── screens/
│   ├── home_screen.dart        # Main monitoring UI
│   ├── settings_screen.dart    # Settings & logs
│   └── analytics_screen.dart   # Analytics dashboard
├── services/
│   ├── bluetooth_service.dart  # Bluetooth communication
│   └── analytics_service.dart  # Analytics calculations
├── utils/
│   ├── sound_player.dart       # Audio alerts
│   ├── storage_service.dart    # Emergency logs storage
│   └── theme_provider.dart     # Theme management
└── theme/
    └── app_theme.dart          # UI theme definitions

assets/
├── sounds/
│   ├── fire_alert.mp3          # Fire alert sound
│   └── magnetic_alert.mp3      # Magnetic alert sound
└── icons/
    └── app_icon.png            # App icon
```

### **Common Commands**

```bash
# Run the app
flutter run

# Run in debug mode with logs
flutter run -v

# Build release APK
flutter build apk --release

# Check code for issues
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test

# Clean build artifacts
flutter clean
```

### **Troubleshooting**

**Bluetooth Not Working?**
```bash
flutter run -v  # Check logs for permission errors
```

**Sound Not Playing?**
1. Check device volume (not muted)
2. Verify `assets/sounds/` directory exists
3. Run: `flutter clean && flutter pub get`

**Build Errors?**
```bash
flutter clean
flutter pub get
flutter run
```

**Permission Issues?**
- Go to Android Settings → Apps → esp32_security_app → Permissions
- Enable: Bluetooth, Notifications

---

## 📊 Analytics Dashboard

Access via **Settings → 📊 View Analytics & Insights**

### **Risk Levels:**
- 🟢 **LOW** - Few alerts, system stable
- 🟡 **MEDIUM** - Some alerts, review needed
- 🔴 **HIGH** - Many alerts, investigate immediately

### **Key Metrics:**
- **Total Alerts** - Count of all alerts
- **Peak Time** - When most alerts occur
- **Average Gap** - Minutes between consecutive alerts
- **Trend** - % change from previous period

### **Timeline Graph:**
- Red line 🔥 = Fire alerts by hour
- Blue line 🧲 = Magnetic alerts by hour
- Shows patterns and clusters in data

---

## 🛠️ Technology Stack

- **Framework:** Flutter (Dart)
- **UI State:** Provider package
- **Bluetooth:** flutter_bluetooth_serial
- **Audio:** audioplayers
- **Storage:** path_provider + JSON
- **Graphs:** fl_chart
- **Notifications:** flutter_local_notifications
- **Theme:** Material Design

---

## 📈 Version History

- **v1.0.0** - Initial release with Bluetooth and alerts
- **v1.1.0** - Added analytics dashboard and graphs

---

**Last Updated:** October 25, 2025  
**Status:** ✅ Production Ready
