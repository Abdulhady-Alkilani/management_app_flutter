# تقرير حالة مشروع Flutter (System Handover Report for AI Agent)

هذا التقرير مخصص لـ AI Agent كمدخل (Context) لإكمال تطوير تطبيق الموبايل (Flutter) الخاص بنظام إدارة مشاريع البناء.

## 1. النظرة العامة (Overview)
- **اسم المشروع:** `mangment_app_flutter`
- **التكنولوجيا:** Flutter للواجهات، و Laravel Sanctum (REST API) للواجهة الخلفية.
- **إدارة الحالة (State Management):** `Provider`.
- **الملاحة (Routing):** `go_router`.
- **الاتصال بالشبكة:** `dio`.
- **هيكلية المشروع:** مبنية على MVVM مع فصل الطبقات (معمارية واضحة في مجلد `lib`).

## 2. ما تم إنجازه حتى الآن (Current State)

### أ. البنية التحتية والمكاتب (Dependencies)
- تم إعداد `pubspec.yaml` بجميع الحزم اللازمة: `dio`, `provider`, `shared_preferences`, `go_router`, `google_fonts`.
- تم تهيئة التطبيق ليدعم اللغة العربية (RTL) بشكل افتراضي من خلال `Directionality` في `main.dart`.

### ب. طبقة الشبكة والاتصال (Network Layer)
- ملف `api_constants.dart`: يحتوي على كافة مسارات الـ API والـ Base URL (المضبوط حالياً للعمل على المحاكي المحلي كـ `http://10.0.2.2:8000/api/v1`).
- `dio_client.dart`: تم إعداد معترض (Interceptor) للـ Dio يرفق `Bearer Token` تلقائياً مع كل طلب، ويتعامل مع خطأ `401 Unauthorized` لتسجيل خروج المستخدم ومسح الجلسة.

### ج. المصادقة والملاحة (Auth & Routing)
- نظام مصادقة مكتمل بهيكل `UserModel`, `AuthRepository` و `AuthProvider`.
- الـ `AppRouter` جاهز مع (Router Guards):
  - فحص توفر التوكن.
  - التوجيه المشروط بناءً على الصلاحية: المهندس (`Engineer`) يذهب إلى `/engineer_home`، والعامل (`Worker`) يذهب إلى `/worker_home`.

### د. واجهات المستخدم الأساسية (UI Skeletons)
تم بناء هياكل واجهات المستخدم الأساسية (UI Skeletons) وتوزيعها في المجلدات التالية:
- **Auth:** `login_screen.dart` (جاهزة كلياً ومتصلة بالـ Provider).
- **Engineer:** 
  - الشاشة الرئيسية (`engineer_home_screen.dart`).
  - شاشة السيرة الذاتية (`engineer_cv_screen.dart`).
  - شاشة المشاريع (`engineer_projects_screen.dart`).
  - شاشة المهام والتفاصيل (`engineer_tasks_screen.dart`, `engineer_task_details_screen.dart`).
  - شاشة التقارير والتفاصيل (`engineer_reports_screen.dart`, `report_details_screen.dart`).
- **Worker:**
  - الشاشة الرئيسية (`worker_home_screen.dart`).
  - شاشة السيرة الذاتية (`worker_cv_screen.dart`).
  - شاشة المهام والتفاصيل (`worker_tasks_screen.dart`, `worker_task_details_screen.dart`).
  - شاشة الورشات (`worker_workshops_screen.dart`).

---

## 3. خارطة الطريق والمطلوب من الـ AI Agent إكماله (Action Items)

المشروع الآن مهيأ من ناحية الـ Routing والـ State Management والـ Network. دورك كـ AI Agent هو الدخول في التنفيذ الفعلي لعمليات (Data Fetching) والتحديثات (UI Linking)، وذلك بالخطوات التالية:

### المهمة الأولى: تفعيل العمليات الشبكية في الـ Providers
1. **`EngineerProvider`**:
   - بناء دوال جلب السيرة الذاتية (`fetchCV`) وتحديثها.
   - بناء دوال جلب المشاريع (`fetchProjects`)، المهام (`fetchTasks`)، والتقارير (`fetchReports`).
   - بناء دوال إرسال وتعديل المهام والتقارير.
2. **`WorkerProvider`**:
   - بناء دوال جلب المهام والورشات (`fetchTasks`, `fetchWorkshops`).
   - بناء دوال تحديث السيرة الذاتية ورفع التقدم الخاص بالمهام (`updateTaskProgress`).

### المهمة الثانية: ربط الواجهات (UI) بالبيانات الفعلية
- الانتقال إلى شاشات الـ `engineer` والـ `worker` (مثال: `engineer_tasks_screen.dart`) وتنظيف الأكواد الوهمية (Mock Data) أو الأزرار المؤقتة.
- استخدام `Consumer<EngineerProvider>` (أو WorkerProvider) لبناء الـ UI بناءً على الحالة (Loading, Success, Error).
- إضافة دوارات التحميل (Spinners/Shimmer) ورسائل الأخطاء (Snackbars) لتجربة مستخدم سلسة.

### المهمة الثالثة: توافق النماذج (Models Parsing)
- الدخول إلى مجلد `lib/models` واستكمال `TaskModel`, `ProjectModel`, `ReportModel`, و `CvModel` لعمل Parse صحيح من الـ JSON القادم من خادم Laravel اعتماداً على ما هو موثق في `apiDoc.md` الموجود ضمن ملفات المشروع.

### المهمة الرابعة: الالتزام بمعايير التصميم (Design Standards)
- التطبيق يعتمد هيكلية احترافية، لذا يجب أن يكون التصميم تفاعلياً (Responsive).
- استخدام الألوان والثيمات الموحدة الموجودة في `AppTheme.lightTheme`.
- الحرص على بقاء النصوص والمحاذاة RTL ليتناسب مع اللغة العربية.

---
**توجيه أخير للوكيل الذكي (AI Agent):** 
اعتمد دائماً على المراجع الموجودة في `apiDoc.md` لضمان كتابة `Keys` صحيحة لطلبات واستجابات الـ API. لا تقم بتغيير معمارية المجلدات (MVVM)، بل أكمل عليها لضمان ثبات المشروع.
