// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'نظام الإدارة';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginSubtitle => 'أدخل بياناتك للمتابعة';

  @override
  String get usernameLabel => 'اسم المستخدم';

  @override
  String get usernameHint => 'يرجى إدخال اسم المستخدم';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordHint => 'يرجى إدخال كلمة المرور';

  @override
  String get loginButton => 'دخول';

  @override
  String get loginFailed => 'فشل تسجيل الدخول. تحقق من البيانات.';

  @override
  String get engineerDashboard => 'لوحة المهندس';

  @override
  String get workerDashboard => 'لوحة العامل';

  @override
  String get projects => 'المشاريع';

  @override
  String get tasks => 'المهام';

  @override
  String get reports => 'التقارير';

  @override
  String get myCv => 'سيرتي';

  @override
  String get workshops => 'الورشات';

  @override
  String get logout => 'تسجيل خروج';

  @override
  String get addSkill => 'إضافة مهارة';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get add => 'إضافة';

  @override
  String get statusCompleted => 'مكتملة';

  @override
  String get statusPending => 'معلقة';

  @override
  String get statusCanceled => 'ملغاة';

  @override
  String get updateTask => 'تحديث المهمة';

  @override
  String get updateTaskProgress => 'تحديث تقدم المهمة';

  @override
  String get taskProgress => 'نسبة الإنجاز';

  @override
  String get taskStatus => 'الحالة';

  @override
  String get noTasks => 'لا توجد مهام حالياً.';

  @override
  String get noProjects => 'لا توجد مشاريع حالياً.';

  @override
  String get noWorkshops => 'لا توجد ورشات حالياً.';

  @override
  String get noReports => 'لا توجد تقارير حالياً.';

  @override
  String get createReport => 'إنشاء تقرير';

  @override
  String get reportTitle => 'عنوان التقرير';

  @override
  String get reportContent => 'محتوى التقرير';

  @override
  String get addReportSuccess => 'تم إضافة التقرير بنجاح';

  @override
  String get addReportFailed => 'فشل إضافة التقرير';

  @override
  String get updateTaskSuccess => 'تم تحديث المهمة بنجاح';

  @override
  String get updateTaskFailed => 'فشل التحديث';

  @override
  String get errorProgressCompleted =>
      'يجب أن تكون الحالة \"مكتملة\" إذا كانت نسبة الإنجاز 100%';

  @override
  String get errorStatusCompleted =>
      'لا يمكن اختيار \"مكتملة\" إلا إذا كانت نسبة الإنجاز 100%';

  @override
  String get addSkillsTitle => 'إضافة مهارات';

  @override
  String get availableSkills => 'المهارات المتاحة:';

  @override
  String get addNewSkills => 'أو أضف مهارات جديدة:';

  @override
  String get skillsHint => 'أدخل المهارات مفصولة بفواصل';

  @override
  String get addSkillsSuccess => 'تمت إضافة المهارات بنجاح';

  @override
  String get addSkillsFailed => 'فشل إضافة المهارات';

  @override
  String get all => 'الكل';

  @override
  String get cvTitle => 'السيرة الذاتية';

  @override
  String get yearsOfExperience => 'سنوات الخبرة';

  @override
  String get skills => 'المهارات:';

  @override
  String get noSkills => 'لا توجد مهارات مضافة';

  @override
  String get generalInfo => 'معلومات عامة';

  @override
  String get workshopInfo => 'معلومات الورشة';

  @override
  String get projectInfo => 'معلومات المشروع';

  @override
  String get description => 'الوصف';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get taskDetails => 'تفاصيل المهمة';

  @override
  String get loading => 'جاري التحميل...';
}
