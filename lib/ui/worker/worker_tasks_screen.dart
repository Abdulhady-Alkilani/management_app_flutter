import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/worker_provider.dart';

class WorkerTasksScreen extends StatefulWidget {
  const WorkerTasksScreen({super.key});

  @override
  State<WorkerTasksScreen> createState() => _WorkerTasksScreenState();
}

class _WorkerTasksScreenState extends State<WorkerTasksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkerProvider>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مهام العامل')),
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

          if (provider.tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, size: 64, color: AppTheme.textSecondary.withAlpha(100)),
                  const SizedBox(height: 16),
                  Text('لا توجد مهام حالياً.', style: GoogleFonts.cairo(fontSize: 16, color: AppTheme.textSecondary)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchTasks(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.tasks.length,
              itemBuilder: (context, index) {
                final task = provider.tasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => context.push('/worker/tasks/${task.id}'),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.description, style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 15)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildStatusChip(task.status),
                              const Spacer(),
                              Text('${task.progress}%', style: GoogleFonts.cairo(fontWeight: FontWeight.w700, color: AppTheme.primaryBlue)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: task.progress / 100,
                              minHeight: 6,
                              backgroundColor: AppTheme.divider,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                task.progress >= 100 ? AppTheme.success : AppTheme.primaryBlue,
                              ),
                            ),
                          ),
                          if (task.project != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.business_rounded, size: 14, color: AppTheme.textSecondary),
                                const SizedBox(width: 4),
                                Text(task.project?['name'] ?? '', style: GoogleFonts.cairo(fontSize: 12, color: AppTheme.textSecondary)),
                              ],
                            ),
                          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
