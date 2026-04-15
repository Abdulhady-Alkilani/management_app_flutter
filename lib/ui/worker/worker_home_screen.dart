import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class WorkerHomeScreen extends StatelessWidget {
  const WorkerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final displayName = user?.name ?? '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة العامل'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'تسجيل الخروج',
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
              _buildWelcomeHeader(displayName),
              const SizedBox(height: 28),

              // ── Info Banner ──
              _buildInfoBanner(),
              const SizedBox(height: 28),

              // ── Menu Grid ──
              Text(
                'القائمة الرئيسية',
                style: GoogleFonts.cairo(
                  fontSize: 18,
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
                    title: 'المهام',
                    subtitle: 'متابعة المهام',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                    ),
                    onTap: () {
                      context.push('/worker/tasks');
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.construction_rounded,
                    title: 'الورشات',
                    subtitle: 'الورشات المعيّنة',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00897B), Color(0xFF26A69A)],
                    ),
                    onTap: () {
                      context.push('/worker/workshops');
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.person_rounded,
                    title: 'السيرة الذاتية',
                    subtitle: 'الملف الشخصي',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
                    ),
                    onTap: () {
                      context.push('/worker/cv');
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

  Widget _buildWelcomeHeader(String name) {
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
            child: const Icon(Icons.construction_rounded,
                color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً 👋',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.white.withAlpha(200),
                  ),
                ),
                Text(
                  name.isNotEmpty ? name : 'العامل',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
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

  Widget _buildInfoBanner() {
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
              'يمكنك متابعة مهامك وورشاتك من هنا',
              style: GoogleFonts.cairo(
                fontSize: 13,
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('تسجيل الخروج',
            style: GoogleFonts.cairo(fontWeight: FontWeight.w700)),
        content: Text('هل أنت متأكد من تسجيل الخروج؟',
            style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            child: Text('إلغاء', style: GoogleFonts.cairo()),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text('خروج', style: GoogleFonts.cairo()),
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
                  style: GoogleFonts.cairo(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
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
