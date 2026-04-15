import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/engineer_provider.dart';
import '../../models/task_model.dart';

class EngineerTaskDetailsScreen extends StatefulWidget {
  final int taskId;
  const EngineerTaskDetailsScreen({super.key, required this.taskId});

  @override
  State<EngineerTaskDetailsScreen> createState() => _EngineerTaskDetailsScreenState();
}

class _EngineerTaskDetailsScreenState extends State<EngineerTaskDetailsScreen> {
  TaskModel? _task;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final t = await context.read<EngineerProvider>().getTaskDetails(widget.taskId);
    if (mounted) setState(() => _task = t);
  }

  @override
  Widget build(BuildContext context) {
    if (_task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تفاصيل المهمة')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('مهمة #${_task!.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_task!.description, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStatusChip(_task!.status),
                      const Spacer(),
                      Text('${_task!.progress}%', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.primaryBlue)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _task!.progress / 100,
                      minHeight: 10,
                      backgroundColor: AppTheme.divider,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _task!.progress >= 100 ? AppTheme.success : AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_task!.project != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.business_rounded, color: AppTheme.primaryBlue),
                title: Text('المشروع', style: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 13)),
                subtitle: Text(_task!.project?['name'] ?? '', style: GoogleFonts.cairo(fontSize: 15)),
              ),
            ),
          if (_task!.workshop != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.construction_rounded, color: AppTheme.primaryBlue),
                title: Text('الورشة', style: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 13)),
                subtitle: Text(_task!.workshop?['name'] ?? '', style: GoogleFonts.cairo(fontSize: 15)),
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => _showUpdateTaskDialog(context),
              icon: const Icon(Icons.edit_rounded),
              label: Text('تحديث المهمة', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'مكتملة':
        color = AppTheme.success;
        break;
      case 'معلقة':
        color = AppTheme.warning;
        break;
      case 'ملغاة':
        color = AppTheme.error;
        break;
      default:
        color = AppTheme.primaryBlue;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
    );
  }

  void _showUpdateTaskDialog(BuildContext context) {
    double progress = (_task?.progress ?? 0).toDouble();
    String selectedStatus = _task?.status ?? 'قيد التنفيذ';
    final statusOptions = ['قيد التنفيذ', 'مكتملة', 'معلقة', 'ملغاة'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('تحديث المهمة', style: GoogleFonts.cairo(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('الإنجاز: ${progress.round()}%', style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
              Slider(
                value: progress,
                min: 0,
                max: 100,
                divisions: 20,
                label: '${progress.round()}%',
                activeColor: AppTheme.primaryBlue,
                onChanged: (v) => setDialogState(() => progress = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedStatus,
                decoration: const InputDecoration(labelText: 'الحالة'),
                items: statusOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setDialogState(() => selectedStatus = v!),
              ),
            ],
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
                final success = await provider.updateTask(widget.taskId, {
                  'progress': progress.round(),
                  'status': selectedStatus,
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'تم تحديث المهمة بنجاح' : 'فشل التحديث'),
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
      ),
    );
  }
}
