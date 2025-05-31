import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/user_profile.dart';

final userProvider = FutureProvider.family<UserProfile, String>((ref, email) async {
  final baseUrl = dotenv.env['BACKEND_URL'];
  final url = Uri.parse('$baseUrl/auth/user/$email');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return UserProfile.fromJson(json);
  } else {
    throw Exception('Failed to load user profile');
  }
});