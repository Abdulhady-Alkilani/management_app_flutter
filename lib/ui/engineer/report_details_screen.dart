import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/engineer_provider.dart';
import '../../models/report_model.dart';

class ReportDetailsScreen extends StatefulWidget {
  final int reportId;
  const ReportDetailsScreen({super.key, required this.reportId});

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  ReportModel? _report;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final r = await context.read<EngineerProvider>().getReportDetails(widget.reportId);
    if (mounted) setState(() => _report = r);
  }

  @override
  Widget build(BuildContext context) {
    if (_report == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تفاصيل التقرير')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('تقرير #${_report!.id}'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _showEditReportDialog(context);
              } else if (value == 'delete') {
                _showDeleteConfirmDialog(context);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'edit', child: Text('تعديل')),
              const PopupMenuItem(value: 'delete', child: Text('حذف')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.accentCyan.withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(_report!.reportType, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryMid)),
                      ),
                      const Spacer(),
                      Text('#${_report!.id}', style: GoogleFonts.cairo(fontSize: 13, color: AppTheme.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('تفاصيل التقرير', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                  const SizedBox(height: 8),
                  Text(_report!.reportDetails, style: GoogleFonts.cairo(fontSize: 16, height: 1.6)),
                ],
              ),
            ),
          ),
          if (_report!.projectId != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.business_rounded, color: AppTheme.primaryBlue),
                title: Text('المشروع', style: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 13)),
                subtitle: Text('معرف المشروع: ${_report!.projectId}', style: GoogleFonts.cairo(fontSize: 14)),
              ),
            ),
        ],
      ),
    );
  }

  void _showEditReportDialog(BuildContext context) {
    final detailsController = TextEditingController(text: _report?.reportDetails ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('تعديل التقرير', style: GoogleFonts.cairo(fontWeight: FontWeight.w700)),
        content: TextField(
          controller: detailsController,
          decoration: const InputDecoration(labelText: 'تفاصيل التقرير'),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = context.read<EngineerProvider>();
              final success = await provider.updateReport(widget.reportId, {
                'report_details': detailsController.text.trim(),
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'تم تعديل التقرير بنجاح' : 'فشل التعديل'),
                    backgroundColor: success ? AppTheme.success : AppTheme.error,
                  ),
                );
                if (success) await _loadDetails();
              }
            },
            child: Text('حفظ', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('حذف التقرير', style: GoogleFonts.cairo(fontWeight: FontWeight.w700)),
        content: Text('هل أنت متأكد من حذف هذا التقرير؟ لا يمكن التراجع عن هذا الإجراء.', style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = context.read<EngineerProvider>();
              final success = await provider.deleteReport(widget.reportId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'تم حذف التقرير بنجاح' : 'فشل الحذف'),
                    backgroundColor: success ? AppTheme.success : AppTheme.error,
                  ),
                );
                if (success) Navigator.pop(context);
              }
            },
            child: Text('حذف', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }
}
