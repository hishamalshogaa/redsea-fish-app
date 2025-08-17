# إعداد طبقة الأقمار الصناعية

هناك طريقتان رئيسيتان:
1) استخدام مزود جاهز لبلاطات XYZ/WMTS لصور Sentinel-2 أو Planet أو غيرها.
2) إعداد Sentinel Hub (مدفوع/تجريبي) وإنشاء **WMTS** ثم تمريره عبر خادمك كـ **XYZ**.

## الخطوات المختصرة
- فعّل خادم `server/sentinel_proxy.py`:
```bash
python -m venv .venv && source .venv/bin/activate
pip install fastapi uvicorn requests python-dotenv
cp .env.example .env  # حدّث القيم
uvicorn sentinel_proxy:app --reload --port 8080
```
- حدّث `SENTINEL_XYZ_TEMPLATE` في `.env` إلى رابط البلاطات من مزودك.
- في تطبيق Flutter، مرّر عنوان الخادم عبر متغير تشغيل:
```bash
flutter run --dart-define=SATELLITE_XYZ_URL=http://YOUR_SERVER:8080/tiles/{z}/{x}/{y}.png
```
- افتح التطبيق وشغّل مفتاح "صورة قمر صناعي" من الشريط العلوي.

## ملاحظات

- طبقة الأقمار الصناعية تعرض **صور سطحية**؛ تقدير العمق بدقة عالية غير مضمون من الأقمار الصناعية وحدها، خصوصًا في المياه العميقة أو العكرة.

- بإمكانك لاحقًا إضافة مؤشرات مثل (Benthic Index) أو تصنيف قاع البحر عبر معالجة متعددة المطياف.

