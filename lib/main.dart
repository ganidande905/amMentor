import 'package:ammentor/screen/auth/provider/auth_provider.dart';
import 'package:ammentor/screen/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'components/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const ProviderScope(child: MyApp()));
}
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    initializeUserEmail(ref);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'amMentor',
      theme: appTheme,
      home: const WelcomeScreen(),
    );
  }
}