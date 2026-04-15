import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/engineer_provider.dart';

class EngineerProjectsScreen extends StatefulWidget {
  const EngineerProjectsScreen({super.key});

  @override
  State<EngineerProjectsScreen> createState() => _EngineerProjectsScreenState();
}

class _EngineerProjectsScreenState extends State<EngineerProjectsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EngineerProvider>().fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المشاريع')),
      body: Consumer<EngineerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(provider.errorMessage!),
                  backgroundColor: AppTheme.error,
                ),
              );
              provider.clearError();
            });
          }

          if (provider.projects.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.business_outlined, size: 64, color: AppTheme.textSecondary.withAlpha(100)),
                  const SizedBox(height: 16),
                  Text('لا يوجد مشاريع.', style: GoogleFonts.cairo(fontSize: 16, color: AppTheme.textSecondary)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchProjects(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.projects.length,
              itemBuilder: (context, index) {
                final p = provider.projects[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.business_rounded, color: AppTheme.primaryBlue),
                    ),
                    title: Text(p.name, style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 15)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 10, color: _getStatusColor(p.status)),
                          const SizedBox(width: 6),
                          Text('الحالة: ${p.status}', style: GoogleFonts.cairo(fontSize: 13, color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'مفتوح':
        return AppTheme.success;
      case 'مغلق':
        return AppTheme.error;
      default:
        return AppTheme.warning;
    }
  }
}
