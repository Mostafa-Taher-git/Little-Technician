import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/core/widgets/app_widgets.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';
import 'login_screen.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String username;
  const CreateNewPasswordScreen({super.key, required this.username});

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _passwordCtrl.dispose();
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
                    const Gap(20),
                    const Text(
                      'New Password',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const Gap(8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.white54, fontSize: 14),
                        children: [
                          const TextSpan(text: 'Setting password for '),
                          TextSpan(text: widget.username, style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const Gap(40),

                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        hintText: '••••••••',
                        labelStyle: const TextStyle(color: Colors.white54),
                        hintStyle: const TextStyle(color: Colors.white30),
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54),
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
                      validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
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
                                  final ok = await AuthService.updatePassword(
                                    username: widget.username,
                                    newPassword: _passwordCtrl.text,
                                  );
                                  setState(() => _loading = false);
                                  if (!context.mounted) return;
                                  if (ok) {
                                    showSuccessToast(context, 'Password updated!');
                                    Nav.replaceAll(context, const LoginScreen());
                                  } else {
                                    showErrorToast(context, 'Failed to update password.');
                                  }
                                }
                              },
                        child: _loading
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent))
                            : const Text('Update Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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
