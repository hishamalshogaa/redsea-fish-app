@echo off
setlocal enabledelayedexpansion

echo ============================================
echo  Red Sea Fish App - Android APK Builder
echo ============================================

where flutter >nul 2>nul
if errorlevel 1 (
  echo [!] Flutter غير مُثبّت أو غير موجود في PATH.
  echo     حمّل Flutter: https://flutter.dev/docs/get-started/install/windows
  pause
  exit /b 1
)

set PROJ=redsea_fish_app
if not exist "%PROJ%" (
  echo [*] إنشاء مشروع Flutter جديد...
  flutter create --platforms=android "%PROJ%"
)

echo [*] نسخ الملفات إلى المشروع...
xcopy /E /Y app\lib "%PROJ%\lib" >nul
xcopy /E /Y app\assets "%PROJ%\assets" >nul
copy /Y app\pubspec.yaml "%PROJ%\pubspec.yaml" >nul

echo [*] تمكين شبكات الإنترنت والموقع للأندرويد...
powershell -Command "(Get-Content '%PROJ%\android\app\src\main\AndroidManifest.xml') -replace '<application', '<uses-permission android:name=\"android.permission.INTERNET\"/>\n    <uses-permission android:name=\"android.permission.ACCESS_FINE_LOCATION\"/>\n    <uses-permission android:name=\"android.permission.ACCESS_COARSE_LOCATION\"/>\n    <application' | Set-Content '%PROJ%\android\app\src\main\AndroidManifest.xml'"

echo [*] تثبيت الحزم...
cd "%PROJ%"
flutter pub get

echo [*] بناء ملف APK (قد يستغرق بعض الوقت أول مرة)...
flutter build apk --release

cd ..
set APK=%PROJ%\build\app\outputs\flutter-apk\app-release.apk
if exist "%APK%" (
  echo [✓] تم إنشاء APK: %APK%
  echo يمكنك نقله إلى هاتفك وتثبيته.
) else (
  echo [!] فشل البناء. افحص السجل أعلاه.
)
pause
