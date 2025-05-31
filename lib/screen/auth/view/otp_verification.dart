// import 'dart:convert';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/auth/model/auth_model.dart';
import 'package:ammentor/screen/auth/provider/auth_provider.dart';
import 'package:ammentor/screen/mentees/mentee_dashboard.dart';
import 'package:ammentor/screen/mentor/mentor_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:page_animation_transition/animations/bottom_to_top_faded_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class OtpVerification extends ConsumerStatefulWidget {
  final UserRole userRole;
  final String email;

  const OtpVerification({
    super.key,
    required this.userRole,
    required this.email,
  });

  @override
  ConsumerState<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends ConsumerState<OtpVerification> {
  final _formKey = GlobalKey<FormState>();
  final pin1Controller = TextEditingController();
  final pin2Controller = TextEditingController();
  final pin3Controller = TextEditingController();
  final pin4Controller = TextEditingController();

  bool isLoading = false;

  Future<void> submitOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final otp = pin1Controller.text +
        pin2Controller.text +
        pin3Controller.text +
        pin4Controller.text;

    setState(() => isLoading = true);

    ref.read(userEmailProvider.notifier).state = widget.email;

    final controller = AuthController();
    final response = await controller.verifyOtp(widget.email, otp);
    if (!mounted) return;

    if (response.success) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', widget.email);
    
    ref.read(userEmailProvider.notifier).state = widget.email;
      final Widget targetPage = widget.userRole == UserRole.mentor
          ? const MentorHomePage()
          : const MenteeHomePage();

      Navigator.of(context).pushReplacement(
        PageAnimationTransition(
          page: targetPage,
          pageAnimationType: BottomToTopFadedTransition(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
    }

    setState(() => isLoading = false);
  }

  String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2 || parts[0].length < 2) return email;
    final visible = parts[0].substring(0, 2);
    return '$visible****@${parts[1]}';
  }

  bool isOtpComplete() {
    return pin1Controller.text.isNotEmpty &&
        pin2Controller.text.isNotEmpty &&
        pin3Controller.text.isNotEmpty &&
        pin4Controller.text.isNotEmpty;
  }

  Widget buildOtpBox(TextEditingController controller) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.068,
      width: screenHeight * 0.064,
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          if (value.length == 1) FocusScope.of(context).nextFocus();
          setState(() {}); // refresh button enable state
        },
        decoration: const InputDecoration(
          hintText: "0",
          hintStyle: TextStyle(color: AppColors.darkgrey),
        ),
        style: AppTextStyles.input(context).copyWith(fontWeight: FontWeight.w600),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        validator: (value) => value == null || value.isEmpty ? '' : null,
      ),
    );
  }

  Widget buildTopSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.024),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Verification code", style: AppTextStyles.heading(context).copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: screenHeight * 0.008),
          Text("We have sent the verification code to", style: AppTextStyles.caption(context).copyWith(color: AppColors.grey)),
          SizedBox(height: screenHeight * 0.004),
          Text(maskEmail(widget.email), style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.white)),
          SizedBox(height: screenHeight * 0.01),
          Text('Change email?', style: AppTextStyles.caption(context).copyWith(color: AppColors.primary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTopSection(),
            SizedBox(height: screenHeight * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildOtpBox(pin1Controller),
                const SizedBox(width: 12),
                buildOtpBox(pin2Controller),
                const SizedBox(width: 12),
                buildOtpBox(pin3Controller),
                const SizedBox(width: 12),
                buildOtpBox(pin4Controller),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: isOtpComplete() && !isLoading ? submitOtp : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.09,
                  vertical: screenHeight * 0.015,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text("Login", style: AppTextStyles.caption(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}