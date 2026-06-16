import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/core/widgets/app_widgets.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';
import 'create_new_password_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Back
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () => Nav.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
                      ),
                    ),
                    const Gap(20),
                    const Text(
                      'Reset Password',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const Gap(8),
                    const Text(
                      'Enter your registered username to verify your account.',
                      style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.5),
                    ),
                    const Gap(40),

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
                        errorStyle: const TextStyle(color: AppColors.error),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Enter your username' : null,
                    ),
                    const Gap(32),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.onAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _loading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _loading = true);
                                  final exists = await AuthService.userExists(_usernameCtrl.text.trim());
                                  setState(() => _loading = false);
                                  if (!context.mounted) return;
                                  if (exists) {
                                    Nav.push(context, CreateNewPasswordScreen(username: _usernameCtrl.text.trim()));
                                  } else {
                                    showErrorToast(context, 'Account not found.');
                                  }
                                }
                              },
                        child: _loading
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent))
                            : const Text('Verify Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
