import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/worker_provider.dart';

class WorkerWorkshopsScreen extends StatefulWidget {
  const WorkerWorkshopsScreen({super.key});

  @override
  State<WorkerWorkshopsScreen> createState() => _WorkerWorkshopsScreenState();
}

class _WorkerWorkshopsScreenState extends State<WorkerWorkshopsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkerProvider>().fetchWorkshops();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الورشات')),
      body: Consumer<WorkerProvider>(
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

          if (provider.workshops.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.construction_outlined, size: 64, color: AppTheme.textSecondary.withAlpha(100)),
                  const SizedBox(height: 16),
                  Text('لا يوجد ورشات معينة لك.', style: GoogleFonts.cairo(fontSize: 16, color: AppTheme.textSecondary)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchWorkshops(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.workshops.length,
              itemBuilder: (context, index) {
                final w = provider.workshops[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00897B).withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.construction_rounded, color: Color(0xFF00897B)),
                    ),
                    title: Text(w.name, style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 15)),
                    subtitle: w.project?['name'] != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.business_rounded, size: 14, color: AppTheme.textSecondary),
                                const SizedBox(width: 4),
                                Text('المشروع: ${w.project?['name']}', style: GoogleFonts.cairo(fontSize: 13, color: AppTheme.textSecondary)),
                              ],
                            ),
                          )
                        : null,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
