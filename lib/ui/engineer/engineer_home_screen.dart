import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

class EngineerHomeScreen extends StatelessWidget {
  const EngineerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final displayName = user?.name ?? '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.engineerDashboard),
        actions: [
          // ── Language Toggle ──
          Consumer<LocaleProvider>(
            builder: (context, localeProvider, _) {
              final isArabic = localeProvider.locale.languageCode == 'ar';
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () => localeProvider.toggleLocale(),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.translate_rounded, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          isArabic ? 'EN' : 'ع',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: l10n.logout,
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Welcome Header ──
              _buildWelcomeHeader(context, displayName),
              const SizedBox(height: 28),

              // ── Quick Stats (placeholder) ──
              _buildInfoBanner(context),
              const SizedBox(height: 28),

              // ── Menu Grid ──
              Text(
                'القائمة الرئيسية',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _DashboardCard(
                    icon: Icons.assignment_rounded,
                    title: l10n.tasks,
                    subtitle: 'إدارة المهام',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                    ),
                    onTap: () {
                      context.push('/engineer/tasks');
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.business_rounded,
                    title: l10n.projects,
                    subtitle: 'عرض المشاريع',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00897B), Color(0xFF26A69A)],
                    ),
                    onTap: () {
                      context.push('/engineer/projects');
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.description_rounded,
                    title: l10n.reports,
                    subtitle: 'إرسال تقرير',
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE65100), Color(0xFFFF8A65)],
                    ),
                    onTap: () {
                      context.push('/engineer/reports');
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.person_rounded,
                    title: l10n.cvTitle,
                    subtitle: 'الملف الشخصي',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
                    ),
                    onTap: () {
                      context.push('/engineer/cv');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, String name) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDark.withAlpha(50),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha(25),
              border: Border.all(color: Colors.white.withAlpha(60), width: 2),
            ),
            child: const Icon(Icons.engineering_rounded,
                color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً 👋',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(200),
                  ),
                ),
                Text(
                  name.isNotEmpty ? name : 'المهندس',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.accentCyan.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentCyan.withAlpha(60)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: AppTheme.primaryMid, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'يمكنك إدارة مشاريعك ومهامك وتقاريرك من هنا',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryMid,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.logout, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        content: Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.logout),
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthProvider>().logout();
              // GoRouter refreshListenable will handle redirect to login
            },
          ),
        ],
      ),
    );
  }
}

// ─── Dashboard Card Widget ──────────────────────────────────
class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withAlpha(60),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
                const Spacer(),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(190),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
