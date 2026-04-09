import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class EngineerHomeScreen extends StatelessWidget {
  const EngineerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة المهندس'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                context.go('/');
              }
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('مرحباً بك في لوحة تحكم المهندس', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: (){}, child: const Text('السيرة الذاتية (CV)')),
            ElevatedButton(onPressed: (){}, child: const Text('المشاريع (Projects)')),
            ElevatedButton(onPressed: (){}, child: const Text('المهام (Tasks)')),
            ElevatedButton(onPressed: (){}, child: const Text('التقارير (Reports)')),
          ],
        ),
      ),
    );
  }
}
