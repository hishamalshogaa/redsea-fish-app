#!/usr/bin/env bash
set -e

echo "============================================"
echo " Red Sea Fish App - Android APK Builder"
echo "============================================"

if ! command -v flutter >/dev/null 2>&1; then
  echo "[!] Flutter غير مُثبّت أو غير موجود في PATH."
  echo "    ثبّت Flutter: https://docs.flutter.dev/get-started/install"
  exit 1
fi

PROJ=redsea_fish_app
if [ ! -d "$PROJ" ]; then
  echo "[*] إنشاء مشروع Flutter جديد..."
  flutter create --platforms=android "$PROJ"
fi

echo "[*] نسخ الملفات إلى المشروع..."
rsync -a app/lib/ "$PROJ/lib/"
rsync -a app/assets/ "$PROJ/assets/"
cp -f app/pubspec.yaml "$PROJ/pubspec.yaml"

echo "[*] تمكين أذونات الإنترنت والموقع..."
MANIFEST="$PROJ/android/app/src/main/AndroidManifest.xml"
if ! grep -q 'android.permission.INTERNET' "$MANIFEST"; then
  gsed -i '0,/<application/{s//<uses-permission android:name="android.permission.INTERNET"\/>\n    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"\/>\n    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"\/>\n    <application/}' "$MANIFEST" 2>/dev/null ||   sed -i '' $'1,/<application/{s//<uses-permission android:name="android.permission.INTERNET"\/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"\/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"\/>
    <application/}' "$MANIFEST"
fi

echo "[*] تثبيت الحزم..."
pushd "$PROJ" >/dev/null
flutter pub get

echo "[*] بناء APK (أول مرة قد تطول)..."
flutter build apk --release

APK="build/app/outputs/flutter-apk/app-release.apk"
popd >/dev/null

if [ -f "$PROJ/$APK" ]; then
  echo "[✓] تم إنشاء APK: $PROJ/$APK"
  echo "    انسخه لهاتفك وثبّته."
else
  echo "[!] فشل البناء. راجع السجل."
  exit 2
fi
