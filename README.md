# 🌾 Crop Yield Prediction — Flutter + FastAPI

## المحتويات
- `backend/` : FastAPI server بيستضيف الموديلين (Classifier + Regressor)
- `flutter_app/` : تطبيق Flutter كامل

## 1) تشغيل الـ Backend

```bash
cd backend
python3 -m venv venv
source venv/bin/activate      # على ويندوز: venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000
```

اتأكدي إنه شغال: افتحي في المتصفح `http://127.0.0.1:8000/options` المفروض تشوفي قائمة الولايات/المحاصيل.

## 2) تشغيل تطبيق Flutter

```bash
cd flutter_app
flutter pub get
flutter run
```

### ⚠️ مهم جداً — عنوان السيرفر (baseUrl)
في ملف `lib/main.dart` فيه سطر:
```dart
const String baseUrl = "http://10.0.2.2:8000";
```
غيّريه حسب مكان تشغيل التطبيق:
| مكان تشغيل التطبيق | القيمة المطلوبة |
|---|---|
| Android Emulator | `http://10.0.2.2:8000` (الافتراضي حالياً) |
| iOS Simulator | `http://127.0.0.1:8000` |
| متصفح (Chrome) | `http://127.0.0.1:8000` |
| موبايل حقيقي (نفس شبكة الواي فاي) | `http://<IP بتاع جهازك>:8000` مثلاً `http://192.168.1.5:8000` |

عشان تعرفي IP جهازك: على ويندوز `ipconfig`، على ماك/لينكس `ifconfig` أو `ip addr`.

## 3) الاستخدام
افتحي التطبيق → اختاري State / Crop / Season → دخّلي القيم (N, P, K, pH, Temperature, Rainfall, Humidity, Fertilizer, Pesticide) → دوسي **Predict** → هتظهرلك:
- **Yield Category** (Low أحمر / Medium أصفر / High أخضر)
- **Expected Yield** بالرقم

## ملاحظات
- الموديلات دي اتدربت من جديد بنفس الكود بتاع النوتبوك بالظبط، وطابقت 100% مع ملفات الـ encoders اللي بعتيها (le_state, le_crop, feature_columns, overall_mean_yield).
- لو حابة تستضيفي الـ API على استضافة سحابية (Render/Railway/إلخ) بدل جهازك، قوليلي وأظبطلك الإعدادات المناسبة.
