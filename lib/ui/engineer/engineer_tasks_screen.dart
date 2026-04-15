import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/engineer_provider.dart';

class EngineerTasksScreen extends StatefulWidget {
  const EngineerTasksScreen({super.key});

  @override
  State<EngineerTasksScreen> createState() => _EngineerTasksScreenState();
}

class _EngineerTasksScreenState extends State<EngineerTasksScreen> {
  int? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<EngineerProvider>();
      provider.fetchProjects();
      provider.fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المهام')),
      body: Consumer<EngineerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.tasks.isEmpty) {
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

          return Column(
            children: [
              _buildProjectFilter(provider),
              Expanded(
                child: provider.tasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.assignment_outlined, size: 64, color: AppTheme.textSecondary.withAlpha(100)),
                            const SizedBox(height: 16),
                            Text('لا توجد مهام حالياً.', style: GoogleFonts.cairo(fontSize: 16, color: AppTheme.textSecondary)),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => provider.fetchTasks(projectId: _selectedProjectId),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: provider.tasks.length,
                          itemBuilder: (context, index) {
                            final task = provider.tasks[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => context.push('/engineer/tasks/${task.id}'),
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProjectFilter(EngineerProvider provider) {
    if (provider.projects.isEmpty) return const SizedBox.shrink();
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ChoiceChip(
              label: Text('الكل', style: GoogleFonts.cairo()),
              selected: _selectedProjectId == null,
              onSelected: (_) {
                setState(() => _selectedProjectId = null);
                provider.fetchTasks();
              },
            ),
          ),
          ...provider.projects.map((p) => Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ChoiceChip(
              label: Text(p.name, style: GoogleFonts.cairo()),
              selected: _selectedProjectId == p.id,
              onSelected: (_) {
                setState(() => _selectedProjectId = p.id);
                provider.fetchTasks(projectId: p.id);
              },
            ),
          )),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
