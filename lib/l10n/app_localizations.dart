import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'نظام الإدارة'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بياناتك للمتابعة'**
  String get loginSubtitle;

  /// No description provided for @usernameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستخدم'**
  String get usernameLabel;

  /// No description provided for @usernameHint.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال اسم المستخدم'**
  String get usernameHint;

  /// No description provided for @passwordLabel.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال كلمة المرور'**
  String get passwordHint;

  /// No description provided for @loginButton.
  ///
  /// In ar, this message translates to:
  /// **'دخول'**
  String get loginButton;

  /// No description provided for @loginFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل تسجيل الدخول. تحقق من البيانات.'**
  String get loginFailed;

  /// No description provided for @engineerDashboard.
  ///
  /// In ar, this message translates to:
  /// **'لوحة المهندس'**
  String get engineerDashboard;

  /// No description provided for @workerDashboard.
  ///
  /// In ar, this message translates to:
  /// **'لوحة العامل'**
  String get workerDashboard;

  /// No description provided for @projects.
  ///
  /// In ar, this message translates to:
  /// **'المشاريع'**
  String get projects;

  /// No description provided for @tasks.
  ///
  /// In ar, this message translates to:
  /// **'المهام'**
  String get tasks;

  /// No description provided for @reports.
  ///
  /// In ar, this message translates to:
  /// **'التقارير'**
  String get reports;

  /// No description provided for @myCv.
  ///
  /// In ar, this message translates to:
  /// **'سيرتي'**
  String get myCv;

  /// No description provided for @workshops.
  ///
  /// In ar, this message translates to:
  /// **'الورشات'**
  String get workshops;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل خروج'**
  String get logout;

  /// No description provided for @addSkill.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مهارة'**
  String get addSkill;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get add;

  /// No description provided for @statusCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتملة'**
  String get statusCompleted;

  /// No description provided for @statusPending.
  ///
  /// In ar, this message translates to:
  /// **'معلقة'**
  String get statusPending;

  /// No description provided for @statusCanceled.
  ///
  /// In ar, this message translates to:
  /// **'ملغاة'**
  String get statusCanceled;

  /// No description provided for @updateTask.
  ///
  /// In ar, this message translates to:
  /// **'تحديث المهمة'**
  String get updateTask;

  /// No description provided for @updateTaskProgress.
  ///
  /// In ar, this message translates to:
  /// **'تحديث تقدم المهمة'**
  String get updateTaskProgress;

  /// No description provided for @taskProgress.
  ///
  /// In ar, this message translates to:
  /// **'نسبة الإنجاز'**
  String get taskProgress;

  /// No description provided for @taskStatus.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get taskStatus;

  /// No description provided for @noTasks.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مهام حالياً.'**
  String get noTasks;

  /// No description provided for @noProjects.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مشاريع حالياً.'**
  String get noProjects;

  /// No description provided for @noWorkshops.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد ورشات حالياً.'**
  String get noWorkshops;

  /// No description provided for @noReports.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تقارير حالياً.'**
  String get noReports;

  /// No description provided for @createReport.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء تقرير'**
  String get createReport;

  /// No description provided for @reportTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان التقرير'**
  String get reportTitle;

  /// No description provided for @reportContent.
  ///
  /// In ar, this message translates to:
  /// **'محتوى التقرير'**
  String get reportContent;

  /// No description provided for @addReportSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إضافة التقرير بنجاح'**
  String get addReportSuccess;

  /// No description provided for @addReportFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل إضافة التقرير'**
  String get addReportFailed;

  /// No description provided for @updateTaskSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث المهمة بنجاح'**
  String get updateTaskSuccess;

  /// No description provided for @updateTaskFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل التحديث'**
  String get updateTaskFailed;

  /// No description provided for @errorProgressCompleted.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تكون الحالة \"مكتملة\" إذا كانت نسبة الإنجاز 100%'**
  String get errorProgressCompleted;

  /// No description provided for @errorStatusCompleted.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن اختيار \"مكتملة\" إلا إذا كانت نسبة الإنجاز 100%'**
  String get errorStatusCompleted;

  /// No description provided for @addSkillsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مهارات'**
  String get addSkillsTitle;

  /// No description provided for @availableSkills.
  ///
  /// In ar, this message translates to:
  /// **'المهارات المتاحة:'**
  String get availableSkills;

  /// No description provided for @addNewSkills.
  ///
  /// In ar, this message translates to:
  /// **'أو أضف مهارات جديدة:'**
  String get addNewSkills;

  /// No description provided for @skillsHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل المهارات مفصولة بفواصل'**
  String get skillsHint;

  /// No description provided for @addSkillsSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة المهارات بنجاح'**
  String get addSkillsSuccess;

  /// No description provided for @addSkillsFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل إضافة المهارات'**
  String get addSkillsFailed;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @cvTitle.
  ///
  /// In ar, this message translates to:
  /// **'السيرة الذاتية'**
  String get cvTitle;

  /// No description provided for @yearsOfExperience.
  ///
  /// In ar, this message translates to:
  /// **'سنوات الخبرة'**
  String get yearsOfExperience;

  /// No description provided for @skills.
  ///
  /// In ar, this message translates to:
  /// **'المهارات:'**
  String get skills;

  /// No description provided for @noSkills.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مهارات مضافة'**
  String get noSkills;

  /// No description provided for @generalInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات عامة'**
  String get generalInfo;

  /// No description provided for @workshopInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الورشة'**
  String get workshopInfo;

  /// No description provided for @projectInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات المشروع'**
  String get projectInfo;

  /// No description provided for @description.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get description;

  /// No description provided for @startDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ البدء'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الانتهاء'**
  String get endDate;

  /// No description provided for @taskDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المهمة'**
  String get taskDetails;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get loading;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
