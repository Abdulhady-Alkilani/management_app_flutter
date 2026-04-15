import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/engineer_provider.dart';

class EngineerReportsScreen extends StatefulWidget {
  const EngineerReportsScreen({super.key});

  @override
  State<EngineerReportsScreen> createState() => _EngineerReportsScreenState();
}

class _EngineerReportsScreenState extends State<EngineerReportsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EngineerProvider>().fetchReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التقارير')),
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

          if (provider.reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description_outlined, size: 64, color: AppTheme.textSecondary.withAlpha(100)),
                  const SizedBox(height: 16),
                  Text('لا يوجد تقارير.', style: GoogleFonts.cairo(fontSize: 16, color: AppTheme.textSecondary)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchReports(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.reports.length,
              itemBuilder: (context, index) {
                final r = provider.reports[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => context.push('/engineer/reports/${r.id}'),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentCyan.withAlpha(20),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(r.reportType, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryMid)),
                              ),
                              const Spacer(),
                              Text('#${r.id}', style: GoogleFonts.cairo(fontSize: 12, color: AppTheme.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            r.reportDetails,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cairo(fontSize: 14, color: AppTheme.textPrimary),
                          ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add_rounded, color: Colors.white),
        onPressed: () => _showCreateReportDialog(context),
      ),
    );
  }

  void _showCreateReportDialog(BuildContext context) {
    final detailsController = TextEditingController();
    final typeController = TextEditingController(text: 'تقرير دوري');
    int? selectedProjectId;
    final provider = context.read<EngineerProvider>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('إنشاء تقرير جديد', style: GoogleFonts.cairo(fontWeight: FontWeight.w700)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (provider.projects.isNotEmpty)
                  DropdownButtonFormField<int>(
                    initialValue: selectedProjectId,
                    decoration: const InputDecoration(labelText: 'المشروع'),
                    items: provider.projects.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                    onChanged: (v) => setDialogState(() => selectedProjectId = v),
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: typeController,
                  decoration: const InputDecoration(labelText: 'نوع التقرير'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: detailsController,
                  decoration: const InputDecoration(labelText: 'تفاصيل التقرير'),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('إلغاء', style: GoogleFonts.cairo()),
            ),
            ElevatedButton(
              onPressed: () async {
                if (detailsController.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                final success = await provider.createReport({
                  'project_id': selectedProjectId,
                  'report_type': typeController.text.trim(),
                  'report_details': detailsController.text.trim(),
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'تم إنشاء التقرير بنجاح' : 'فشل إنشاء التقرير'),
                      backgroundColor: success ? AppTheme.success : AppTheme.error,
                    ),
                  );
                }
              },
              child: Text('إرسال', style: GoogleFonts.cairo()),
            ),
          ],
        ),
      ),
    );
  }
}
