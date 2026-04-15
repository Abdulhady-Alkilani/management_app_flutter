import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final success = await provider.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'فشل تسجيل الدخول. تحقق من البيانات.',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: AppTheme.error,
          ),
        );
      }
      // On success, GoRouter's refreshListenable will auto-redirect
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll('Exception: ', ''),
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.splashGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Logo ──
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentCyan.withAlpha(60),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icon.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'تسجيل الدخول',
                        style: GoogleFonts.cairo(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'أدخل بياناتك للمتابعة',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: Colors.white.withAlpha(160),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // ── Form Card ──
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(30),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Username
                              TextFormField(
                                controller: _usernameController,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  labelText: 'اسم المستخدم',
                                  prefixIcon: const Icon(
                                    Icons.person_outline_rounded,
                                    color: AppTheme.primaryBlue,
                                  ),
                                  filled: true,
                                  fillColor: AppTheme.surfaceLight,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'يرجى إدخال اسم المستخدم';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Password
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  labelText: 'كلمة المرور',
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: AppTheme.primaryBlue,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppTheme.textSecondary,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  filled: true,
                                  fillColor: AppTheme.surfaceLight,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'يرجى إدخال كلمة المرور';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 28),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryBlue,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        AppTheme.primaryBlue.withAlpha(150),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Text(
                                          'دخول',
                                          style: GoogleFonts.cairo(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
