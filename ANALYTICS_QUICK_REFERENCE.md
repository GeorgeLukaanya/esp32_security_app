# 📊 Analytics Quick Reference

## 🚀 Access Analytics

1. **Open App** → Home Screen
2. **Tap Settings** ⚙️ (top right)
3. **Tap "📊 View Analytics & Insights"** (purple button)
4. **View Your Data!**

---

## 📈 What You See

### **Risk Level Card** (Top)
- 🟢 **LOW** - Few alerts, system stable
- 🟡 **MEDIUM** - Some alerts, monitor
- 🔴 **HIGH** - Many alerts, investigate!

### **Statistics Grid** (Middle)
```
Total Alerts | 🔥 Fire | 🧲 Magnetic
```

### **Detailed Metrics** (Bottom)
- ⏰ Peak Alert Time (when most alerts occur)
- 📊 Average Gap (minutes between alerts)
- 📈 Trend (% change from previous day)

### **Timeline Graph** (Today view only)
- Red line 🔥 = Fire alerts by hour
- Blue line 🧲 = Magnetic alerts by hour
- Shows patterns and clusters

---

## 📱 Period Selection

**Click buttons at top:**

| Button | View |
|--------|------|
| Today | Hourly breakdown + graph |
| Week | Last 7 days summary |
| Month | Current month overview |

---

## 💡 Example Interpretations

### **Normal Day**
```
Risk: 🟢 LOW
Total: 3-5 alerts
Peak Time: Morning (09:00)
Trend: Stable (0%)
→ System is good ✓
```

### **Alert Spike**
```
Risk: 🔴 HIGH
Total: 20+ alerts
Peak Time: 14:30 (concentrated)
Trend: +150% (increasing)
→ Investigate at 2:30 PM ⚠️
```

### **Improving System**
```
Risk: 🟡 MEDIUM (improving)
Total: 12 today (vs 25 yesterday)
Peak Time: 10:00
Trend: -52% (getting better)
→ Keep monitoring ✓
```

---

## 🔍 How to Use Insights

### **Fire Alerts Cluster at Specific Time?**
- Check timeline graph
- Timeline shows spike at 14:00-15:00
- → **Action:** Inspect that location at that time

### **Fire Alert Count Too High?**
- Check risk level (if HIGH)
- Average gap is only 3 minutes
- → **Action:** Stop and investigate immediately

### **Trend Increasing?**
- Compare today vs yesterday
- Trend shows +200%
- → **Action:** Problem is getting worse, urgent

### **Magnetic Alerts Only?**
- Check alert type breakdown
- Only 🧲 Magnetic, no 🔥 Fire
- → **Action:** Probably normal (passing metal objects)

---

## 🛠️ Behind the Scenes

**New Files Added:**
- `lib/services/analytics_service.dart` - Does all calculations
- `lib/screens/analytics_screen.dart` - Beautiful UI
- `ANALYTICS_IMPLEMENTATION.md` - Technical details

**Enhanced Existing:**
- `lib/utils/storage_service.dart` - Date filtering
- `lib/screens/settings_screen.dart` - Added button
- `pubspec.yaml` - Added fl_chart library

---

## ❓ FAQ

**Q: Why only see graph on "Today"?**  
A: Hourly data only makes sense for single day. Week/Month show summaries.

**Q: Can I export this data?**  
A: Currently exports to console. Future: PDF and CSV exports coming.

**Q: How often does it update?**  
A: Recalculates when you change period. Always uses latest logs.

**Q: Is this data real?**  
A: Yes! Uses same logs as "Emergency Logs" screen. Same source.

**Q: What triggers HIGH risk?**  
A: > 5 fire alerts OR > 20 total alerts in the period.

---

## 📊 Risk Level Guide

| Risk | Alerts | Action |
|------|--------|--------|
| 🟢 LOW | < 2 fire & < 10 total | ✓ Monitor normally |
| 🟡 MEDIUM | 2-5 fire OR 10-20 total | ⚠️ Review status |
| 🔴 HIGH | > 5 fire OR > 20 total | 🚨 Investigate now |

---

## 📈 Metrics Explained

**Peak Alert Time**
- The hour when most alerts happen
- Format: HH:00 (e.g., 14:00 = 2 PM)
- Helps identify systematic issues

**Average Gap**
- Minutes between consecutive alerts
- High gap = isolated incidents
- Low gap = concentrated problem

**Trend**
- Percentage change from previous day
- +50% = getting worse
- -50% = getting better
- 0% = stable

---

## 🎯 Common Scenarios

### **Furnace Issues**
```
Timeline shows spike at 14:00-16:00 daily
Peak Time: 15:00
→ Furnace kicks on at that time
→ Check furnace area
```

### **Random Sensor Glitch**
```
Magnetic alerts scattered throughout day
Average Gap: 200 minutes
Peak Time: No clear pattern
→ Probably noise or environment
→ Monitor to confirm
```

### **System Degradation**
```
Week trend: Monday HIGH, Friday LOW
Total decreasing daily
Trend: -75% this week
→ Fix is working!
→ Continue current measures
```

---

## 🔐 Privacy & Security

✅ All data is local (no server upload)  
✅ No cloud sync required  
✅ You can export/delete anytime  
✅ App only processes what you generate  

---

**Version:** 1.1.0  
**Last Updated:** October 25, 2025  
**Status:** ✅ Ready to Use
