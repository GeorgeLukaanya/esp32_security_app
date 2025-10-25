# 🛠️ Project Setup Guide

Complete step-by-step instructions to set up the ESP32 Security App on your machine.

---

## 📋 Prerequisites

Before starting, make sure you have:

### **1. Flutter SDK**
- **Download:** https://flutter.dev/docs/get-started/install
- **Verify installation:**
  ```bash
  flutter --version
  ```
- Should show: `Flutter X.X.X` and Dart version

### **2. Android SDK & Tools**
- Included when you install Android Studio
- **Or separately:** Set `ANDROID_HOME` environment variable
- **Verify:**
  ```bash
  flutter doctor
  ```
- Look for ✅ checkmarks next to Android

### **3. Git**
- **Download:** https://git-scm.com/
- **Verify:**
  ```bash
  git --version
  ```

### **4. ESP32 Bluetooth Device**
- Device must be powered on
- Must be paired via Android Bluetooth settings
- **To pair:**
  - Android Settings → Bluetooth → Scan for devices
  - Select your ESP32 device
  - Confirm pairing on both device and phone

### **5. Android Phone or Emulator**
- Physical device with USB debugging enabled, OR
- Android Emulator running (Android Studio)

---

## ⚙️ System Setup (One-Time)

### **Step 1: Install Flutter**

**macOS/Linux:**
```bash
# Clone Flutter repository
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# Add Flutter to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$PATH:[path-to-flutter]/flutter/bin"

# Verify
flutter --version
```

**Windows:**
- Download .zip from https://flutter.dev
- Extract to `C:\src\flutter`
- Add to PATH: `C:\src\flutter\bin`
- Restart terminal, run `flutter --version`

### **Step 2: Run Flutter Doctor**

```bash
flutter doctor
```

Fix any issues shown (usually Android SDK, licenses, etc.)

**Common fixes:**
```bash
# Accept Android licenses
flutter doctor --android-licenses

# Update Flutter
flutter upgrade

# Get dependencies
flutter pub global activate
```

### **Step 3: Enable USB Debugging (Physical Device)**

For physical Android phone:
1. Go to **Settings → About Phone**
2. Tap **Build Number** 7 times until "Developer Mode" enabled
3. Go to **Settings → Developer Options**
4. Enable **USB Debugging**
5. Connect phone via USB

---

## 🚀 Project Setup (Per Machine)

### **Step 1: Clone Repository**

```bash
# Navigate to where you want the project
cd ~/projects  # or wherever you prefer

# Clone the repository
git clone https://github.com/GeorgeLukaanya/esp32_security_app.git

# Enter directory
cd esp32_security_app
```

### **Step 2: Get Flutter Dependencies**

```bash
flutter pub get
```

**Expected output:**
```
Resolving dependencies...
Downloading packages...
Got dependencies! (XX packages)
```

If you get errors, try:
```bash
flutter clean
flutter pub get
```

### **Step 3: Verify Setup**

```bash
flutter analyze
```

Should show:
```
Analyzing esp32_security_app...
No issues found!
```

---

## 📱 Device Setup

### **Physical Android Phone:**

1. **Connect via USB cable**
   ```bash
   flutter devices
   ```
   Should list your device

2. **Enable USB Debugging:**
   - Settings → Developer Options → USB Debugging ON

3. **Trust the computer:**
   - When prompted on phone, tap "Allow"

### **Android Emulator:**

1. **Open Android Studio**
2. **Tools → Device Manager**
3. **Create Virtual Device** (if needed)
4. **Start Emulator**
5. **Verify:**
   ```bash
   flutter devices
   ```

---

## ✅ First Run

### **Step 1: Start Device Listening**

```bash
# Check device/emulator is ready
flutter devices

# Should show something like:
# SM F731N                 • • android • Android 14
# emulator-5554            • • android • Android 13
```

### **Step 2: Run the App**

```bash
# Default: runs on first available device
flutter run

# Specific device
flutter run -d SM\ F731N

# Debug mode with verbose logs
flutter run -v

# Release mode (faster)
flutter run --release
```

### **Step 3: Wait for Build**

First run takes 2-3 minutes as it compiles everything.

**Expected output:**
```
Launching lib/main.dart on SM F731N in debug mode...
Running Gradle task 'assembleDebug'...
✓ Built build/app/outputs/flutter-apk/app-debug.apk (XX.XMB)
Installing and launching...
[OK] App launched successfully.
```

### **Step 4: App Opens**

The app should now appear on your device/emulator!

---

## 🔐 Grant Permissions

When app first opens, grant these permissions:
- ✅ **Bluetooth Connect**
- ✅ **Bluetooth Scan**  
- ✅ **Notifications**

**If permissions dialog doesn't appear:**
- Android Settings → Apps → esp32_security_app → Permissions
- Enable all listed permissions

---

## 🔌 Connect to ESP32

1. **In Android Settings → Bluetooth:**
   - Pair your ESP32 device first
   - You'll see it as "ESP32" or similar

2. **In the Flutter App:**
   - Tap **"🔗 Connect to ESP32"** button
   - Select your device from the list
   - Wait for "✅ Connected" status

3. **Success!**
   - Green dot appears next to device name
   - Control buttons become active

---

## 🧪 Testing the Setup

### **Test Bluetooth Connection:**
```bash
# In the app, tap "Connect to ESP32"
# Should show your device and connect successfully
```

### **Test Sounds:**
```bash
# In the app, tap "🔊 Test Sounds"
# Select "🔥 Test Fire Alert"
# Should hear alert sound
```

### **Test Logs:**
```bash
# In the app, tap "⚙️ Settings"
# Scroll to "Emergency Logs"
# Should be empty initially
# After testing sounds, logs should appear
```

### **Test Analytics:**
```bash
# Tap "📊 View Analytics & Insights"
# Should show analytics dashboard
# Create some test alerts to populate data
```

---

## 🐛 Troubleshooting

### **"No devices found"**
```bash
# Enable USB Debugging on phone
# Or start Android Emulator
# Then run:
flutter devices
```

### **"Permission denied"**
```bash
# Accept all permission prompts in app
# Or manually enable in:
# Settings → Apps → esp32_security_app → Permissions
```

### **"Bluetooth connection failed"**
```bash
# 1. Pair ESP32 in Android Settings first
# 2. Check ESP32 is powered on
# 3. Restart both devices
# 4. Try connecting again
```

### **"Build failed"**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Or verbose output to see issue
flutter run -v
```

### **"Sound not playing"**
```bash
# 1. Check device volume isn't muted
# 2. Verify assets/sounds/ directory exists
# 3. Run:
flutter clean
flutter pub get
flutter run
```

### **"App crashes on startup"**
```bash
# Check logs
flutter logs

# Clean and retry
flutter clean
flutter pub get
flutter run -v
```

---

## 📊 Useful Commands

| Command | Purpose |
|---------|---------|
| `flutter run` | Run app on device |
| `flutter run -v` | Run with verbose logs |
| `flutter run --release` | Run optimized version |
| `flutter devices` | List connected devices |
| `flutter clean` | Clean build artifacts |
| `flutter pub get` | Get dependencies |
| `flutter analyze` | Check for errors |
| `dart format lib/` | Format code |
| `flutter test` | Run tests |
| `flutter build apk` | Build APK for distribution |

---

## 🔄 Hot Reload During Development

While `flutter run` is running:

- **`r` key** - Hot Reload (fast code updates)
- **`R` key** - Hot Restart (full app restart)
- **`q` key** - Quit

Hot Reload is great for UI changes. Use Hot Restart if you change data models.

---

## 🚢 Building for Release

### **Build APK (for distribution):**
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### **Build AAB (for Google Play):**
```bash
flutter build appbundle
```
Output: `build/app/outputs/bundle/release/app-release.aab`

---

## 📞 Getting Help

If you're stuck:

1. **Check Flutter status:**
   ```bash
   flutter doctor
   ```

2. **See detailed logs:**
   ```bash
   flutter run -v
   ```

3. **Clean everything:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

4. **Check console output:**
   ```bash
   flutter logs
   ```

---

**Status:** ✅ Ready to develop!  
**Last Updated:** October 25, 2025
