import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/engineer_provider.dart';

class EngineerCvScreen extends StatefulWidget {
  const EngineerCvScreen({super.key});

  @override
  State<EngineerCvScreen> createState() => _EngineerCvScreenState();
}

class _EngineerCvScreenState extends State<EngineerCvScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EngineerProvider>().fetchCv();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('السيرة الذاتية - المهندس')),
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

          final cv = provider.cv;
          if (cv == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('لا توجد سيرة ذاتية متوفرة.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showEditCvDialog(context, provider),
                    child: const Text('إنشاء سيرة ذاتية'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchCv(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionCard(
                  icon: Icons.person_outline_rounded,
                  title: 'تفاصيل الملف الشخصي',
                  child: Text(cv.profileDetails, style: GoogleFonts.cairo(fontSize: 14, color: AppTheme.textSecondary)),
                ),
                _buildSectionCard(
                  icon: Icons.work_outline_rounded,
                  title: 'الخبرات',
                  child: Text(cv.experience, style: GoogleFonts.cairo(fontSize: 14, color: AppTheme.textSecondary)),
                ),
                _buildSectionCard(
                  icon: Icons.school_outlined,
                  title: 'التعليم',
                  child: Text(cv.education, style: GoogleFonts.cairo(fontSize: 14, color: AppTheme.textSecondary)),
                ),
                if (cv.aiScore != null)
                  _buildSectionCard(
                    icon: Icons.psychology_outlined,
                    title: 'درجة الذكاء الاصطناعي (AI)',
                    child: Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: (cv.aiScore ?? 0) / 100,
                            backgroundColor: AppTheme.divider,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('${cv.aiScore}%', style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 16, color: AppTheme.primaryBlue)),
                      ],
                    ),
                  ),
                if (cv.cvFileUrl != null)
                  _buildSectionCard(
                    icon: Icons.attach_file_rounded,
                    title: 'ملف السيرة الذاتية',
                    child: Text(cv.cvFileUrl!, style: GoogleFonts.cairo(fontSize: 13, color: AppTheme.primaryBlue)),
                  ),
                _buildSkillsSection(cv.skills),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showEditCvDialog(context, provider),
                        icon: const Icon(Icons.edit_rounded),
                        label: const Text('تعديل السيرة'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showAddSkillsDialog(context, provider),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('إضافة مهارة'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({required IconData icon, required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(title, style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection(List<dynamic> skills) {
    if (skills.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star_outline_rounded, size: 20, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text('المهارات', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map<Widget>((s) {
                final name = s is Map<String, dynamic> ? s['name']?.toString() ?? '' : s.toString();
                return Chip(
                  label: Text(name),
                  backgroundColor: AppTheme.primaryBlue.withAlpha(20),
                  side: BorderSide(color: AppTheme.primaryBlue.withAlpha(40)),
                  labelStyle: GoogleFonts.cairo(color: AppTheme.primaryBlue, fontWeight: FontWeight.w600),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCvDialog(BuildContext context, EngineerProvider provider) {
    final cv = provider.cv;
    final profileController = TextEditingController(text: cv?.profileDetails ?? '');
    final experienceController = TextEditingController(text: cv?.experience ?? '');
    final educationController = TextEditingController(text: cv?.education ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('تعديل السيرة الذاتية', style: GoogleFonts.cairo(fontWeight: FontWeight.w700)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: profileController,
                decoration: const InputDecoration(labelText: 'تفاصيل الملف الشخصي'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: experienceController,
                decoration: const InputDecoration(labelText: 'الخبرات'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: educationController,
                decoration: const InputDecoration(labelText: 'التعليم'),
                maxLines: 2,
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
              Navigator.pop(ctx);
              final success = await provider.updateCv({
                'profile_details': profileController.text.trim(),
                'experience': experienceController.text.trim(),
                'education': educationController.text.trim(),
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'تم تحديث السيرة الذاتية بنجاح' : 'فشل التحديث'),
                    backgroundColor: success ? AppTheme.success : AppTheme.error,
                  ),
                );
              }
            },
            child: Text('حفظ', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _showAddSkillsDialog(BuildContext context, EngineerProvider provider) {
    provider.fetchAvailableSkills();
    final skillController = TextEditingController();
    final Set<int> selectedSkillIds = {};

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => ListenableBuilder(
          listenable: provider,
          builder: (ctx, _) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('إضافة مهارات', style: GoogleFonts.cairo(fontWeight: FontWeight.w700)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (provider.availableSkills.isNotEmpty) ...[
                    Text('المهارات المتاحة:', style: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: provider.availableSkills.map((skill) {
                        final id = skill['id'] as int;
                        final name = skill['name'] as String;
                        final isSelected = selectedSkillIds.contains(id);
                        return FilterChip(
                          label: Text(name),
                          selected: isSelected,
                          onSelected: (selected) {
                            setDialogState(() {
                              if (selected) {
                                selectedSkillIds.add(id);
                              } else {
                                selectedSkillIds.remove(id);
                              }
                            });
                          },
                          selectedColor: AppTheme.primaryBlue.withAlpha(40),
                          checkmarkColor: AppTheme.primaryBlue,
                          labelStyle: GoogleFonts.cairo(
                            color: isSelected ? AppTheme.primaryBlue : AppTheme.textPrimary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                  ],
                  Text('أو أضف مهارات جديدة:', style: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: skillController,
                    decoration: const InputDecoration(
                      labelText: 'أدخل المهارات مفصولة بفواصل',
                      hintText: 'مثال: AutoCAD, Revit, Project Management',
                    ),
                    maxLines: 3,
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
                  Navigator.pop(ctx);
                  final List<dynamic> skills = skillController.text
                      .split(',')
                      .map((s) => s.trim())
                      .where((s) => s.isNotEmpty)
                      .map<dynamic>((s) {
                        final intValue = int.tryParse(s);
                        return intValue ?? s;
                      })
                      .toList();
                  
                  skills.addAll(selectedSkillIds);

                  if (skills.isEmpty) return;
                  final success = await provider.addSkills(skills);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? 'تمت إضافة المهارات بنجاح' : 'فشل إضافة المهارات'),
                        backgroundColor: success ? AppTheme.success : AppTheme.error,
                      ),
                    );
                  }
                },
                child: Text('إضافة', style: GoogleFonts.cairo()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
