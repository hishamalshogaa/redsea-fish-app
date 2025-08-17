# تثبيت نسخة أندرويد (APK) بدون خبرة برمجية

## المتطلبات مرة واحدة
1) ثبّت **Flutter** (Windows/Mac/Linux): [دليل التثبيت الرسمي](https://docs.flutter.dev/get-started/install)
2) فعّل **Android SDK** عبر Android Studio (افتحه مرة واحدة ليحمّل الأدوات).
3) وصّل هاتفك أو فعّل وضع المطوّر لتثبيت APKs (غير مطلوب إن كنت ستنسخ الملف يدويًا فقط).

## خطوات سريعة
1) فك الضغط عن الحزمة.
2) افتح مجلد `scripts/`:
   - على Windows: انقر مزدوجًا `build_android.bat`
   - على Mac/Linux: شغّل `chmod +x build_android.sh && ./build_android.sh`
3) انتظر حتى يظهر المسار:
   `redsea_fish_app/build/app/outputs/flutter-apk/app-release.apk`
4) انقل الملف إلى هاتفك وثبّته.

## تخصيص روابط الطبقات (اختياري)
قبل البناء، عدّل القيم عند تشغيل التطبيق:
```
flutter run --dart-define=SATELLITE_XYZ_URL=http://YOUR_SERVER:8080/tiles/{z}/{x}/{y}.png
```
أو عدّل `.env` في مجلد الخادم وشغّله كما في الوثائق.
