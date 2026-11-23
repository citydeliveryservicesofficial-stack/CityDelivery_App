#!/usr/bin/env bash
# One-time setup: generates the android/ and ios/ folders and applies the permissions this app needs.
# Run from the project root:  bash setup_platforms.sh
set -e
flutter create --org com.citydeliveryservices --project-name city_delivery_services --platforms android,ios .
flutter pub get

python3 - <<'PY'
import re, pathlib

# ---------- Android ----------
mf = pathlib.Path('android/app/src/main/AndroidManifest.xml')
s = mf.read_text()
if 'android.permission.INTERNET' not in s:
    s = s.replace('<application', '<uses-permission android:name="android.permission.INTERNET"/>\n    <application', 1)
s = re.sub(r'android:label="[^"]*"', 'android:label="City Delivery Services"', s, count=1)
if '<queries>' not in s:
    q = '''<queries>
        <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="https"/></intent>
        <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="tel"/></intent>
        <intent><action android:name="android.intent.action.SENDTO"/><data android:scheme="mailto"/></intent>
    </queries>
    '''
    s = s.replace('<application', q + '<application', 1)
mf.write_text(s)

# Debug builds may talk to a plain-http local backend; release builds must use https.
dbg = pathlib.Path('android/app/src/debug/AndroidManifest.xml')
dbg.parent.mkdir(parents=True, exist_ok=True)
dbg.write_text('''<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <application android:usesCleartextTraffic="true"/>
</manifest>
''')

# ---------- iOS ----------
pl = pathlib.Path('ios/Runner/Info.plist')
t = pl.read_text()
add = ''
if 'NSCameraUsageDescription' not in t:
    add += '''	<key>NSCameraUsageDescription</key>
	<string>Take a photo of your product or documents to attach to your request or rider application.</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>Choose a product photo or documents to attach to your request or rider application.</string>
'''
if 'LSApplicationQueriesSchemes' not in t:
    add += '''	<key>LSApplicationQueriesSchemes</key>
	<array><string>https</string><string>tel</string><string>mailto</string></array>
'''
if add:
    t = t.rstrip()
    idx = t.rfind('</dict>')
    t = t[:idx] + add + t[idx:] + '\n'
t = re.sub(r'(<key>CFBundleDisplayName</key>\s*<string>)[^<]*', r'\1City Delivery', t)
pl.write_text(t)
print('Platform files patched.')
PY

dart run flutter_launcher_icons
echo "Done. Run:  flutter run --dart-define=API_URL=https://YOUR-BACKEND/api"
