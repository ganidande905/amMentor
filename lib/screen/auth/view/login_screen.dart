import 'package:ammentor/components/otp_dialog.dart';
import 'package:ammentor/screen/auth/model/auth_model.dart';
import 'package:ammentor/screen/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:ammentor/components/custom_text_field.dart';
import 'package:ammentor/components/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final UserRole userRole;

  const LoginScreen({super.key, required this.userRole});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    ref.read(userEmailProvider.notifier).state = email;

    final auth = AuthController();
    final response = await auth.sendOtp(email);

    if (!mounted) return;

    if (response.success) {
      showDialog(
        context: context,
        builder: (_) => OtpVerificationDialog(
          userRole: widget.userRole,
          email: email,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/gradient.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.08,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  height: screenHeight * 0.2,
                  width: screenWidth * 0.8,
                  child: Image.asset(
                    'assets/images/image.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.userRole == UserRole.mentor
                        ? "Mentor Login"
                        : "Mentee Login",
                    style: AppTextStyles.subheading(context)
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextField(
                    controller: emailController,
                    label: "Email",
                    hintText: "Enter your email",
                    width: screenWidth * 0.8,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: isLoading ? null : sendOtp,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Get OTP',
                            style: AppTextStyles.button(context).copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: screenHeight * -0.08,
              right: screenHeight * -0.1,
              child: Transform.rotate(
                angle: -0.5,
                child: Image.asset(
                  'assets/images/amfoss_bulb_white.png',
                  width: screenWidth * 0.95,
                  height: screenHeight * 0.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}