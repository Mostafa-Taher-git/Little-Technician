import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/core/widgets/app_widgets.dart';
import 'package:littletech/src/features/auth/data/models/user_model.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';
import 'package:littletech/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:littletech/src/features/home/presentation/screens/home_screen.dart';
import 'register_screen.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    _users = await AuthService.getAllUsers();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkGradient),
        child: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) Nav.replaceAll(context, const HomeScreen());
                });
              } else if (state is AuthError) {
                showErrorToast(context, state.message);
              }
            },
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Gap(20),
                      // Logo
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/icon/icon.png',
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                      const Gap(20),
                      const Center(
                        child: Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Gap(6),
                      const Center(
                        child: Text(
                          'Sign in to continue troubleshooting',
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                      ),
                      const Gap(36),

                      // Quick select accounts
                      if (_users.isNotEmpty) ...[
                        const Text('Quick Login', style: TextStyle(color: Colors.white60, fontSize: 12, letterSpacing: 1)),
                        const Gap(10),
                        SizedBox(
                          height: 80,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _users.length,
                            separatorBuilder: (_, __) => const Gap(12),
                            itemBuilder: (_, i) {
                              final u = _users[i];
                              final selected = _usernameCtrl.text == u.username;
                              return GestureDetector(
                                onTap: () => setState(() => _usernameCtrl.text = u.username),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 68,
                                  decoration: BoxDecoration(
                                    color: selected ? AppColors.accent.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: selected ? AppColors.accent : Colors.transparent),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(u.avatarIcon, style: const TextStyle(fontSize: 26)),
                                      const Gap(4),
                                      Text(u.username, style: const TextStyle(color: Colors.white70, fontSize: 10), overflow: TextOverflow.ellipsis, maxLines: 1),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Gap(24),
                      ],

                      // Username
                      TextFormField(
                        controller: _usernameCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'tech_expert',
                          labelStyle: const TextStyle(color: Colors.white54),
                          hintStyle: const TextStyle(color: Colors.white30),
                          prefixIcon: const Icon(Icons.person_outline, color: Colors.white54),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.06),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Enter username' : null,
                      ),
                      const Gap(16),

                      // Password
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscure,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: '••••••••',
                          labelStyle: const TextStyle(color: Colors.white54),
                          hintStyle: const TextStyle(color: Colors.white30),
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white54),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.06),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Enter password' : null,
                      ),
                      const Gap(8),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Nav.push(context, const ForgetPasswordScreen()),
                          child: const Text('Forgot Password?', style: TextStyle(color: Colors.white60, fontSize: 13)),
                        ),
                      ),
                      const Gap(24),

                      // Login button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (_, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: AppColors.onAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(LoginEvent(
                                            username: _usernameCtrl.text.trim(),
                                            password: _passwordCtrl.text,
                                          ));
                                      }
                                    },
                              child: state is AuthLoading
                                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent))
                                  : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            ),
                          );
                        },
                      ),
                      const Gap(24),

                      // Register link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?", style: TextStyle(color: Colors.white54)),
                          TextButton(
                            onPressed: () => Nav.push(context, const RegisterScreen()),
                            child: const Text('Sign Up', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      const Gap(20),
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