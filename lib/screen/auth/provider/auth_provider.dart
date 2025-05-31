import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider;
import 'package:http/http.dart' as http;
import 'package:ammentor/screen/auth/model/auth_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userEmailProvider = StateProvider<String?>((ref) => null);

Future<void> initializeUserEmail(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('user_email');
  ref.read(userEmailProvider.notifier).state = email;
}
class AuthController {

  Future<OtpResponse> sendOtp(String email) async {
        final url = Uri.parse('${dotenv.env['BACKEND_URL']}/auth/send-otp/$email');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return OtpResponse(message: "OTP sent successfully", success: true);
      }
      return OtpResponse(message: "Failed to send OTP", success: false);
    } catch (_) {
      return OtpResponse(message: "Error sending OTP", success: false);
    }
  }

  Future<OtpResponse> verifyOtp(String email, String otp) async {
    final url = Uri.parse(
      '${dotenv.env['BACKEND_URL']}/auth/verify-otp/$email?otp=$otp',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return OtpResponse(message: "OTP verified", success: true);
      }
      final body = jsonDecode(response.body);
      return OtpResponse(message: body['detail'] ?? "Invalid OTP", success: false);
    } catch (_) {
      return OtpResponse(message: "Error verifying OTP", success: false);
    }
  }
}