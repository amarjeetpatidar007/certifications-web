// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_certifications/keys.dart';
import 'package:my_certifications/pages/certification_list_page.dart';
import 'package:my_certifications/pages/sign_in_page.dart';
import 'package:my_certifications/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'provider/certification_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance
      .activate(webProvider: ReCaptchaEnterpriseProvider(CustomKeys.siteKey));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
    ],
    child: const CertificationTrackerApp(),
  ));
}

class CertificationTrackerApp extends StatelessWidget {
  const CertificationTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Certification Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isLoading) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading state
          }
          if (authProvider.isAuthenticated) {
            return ChangeNotifierProvider(
              create: (_) => CertificationProvider(authProvider.user!.uid),
              builder: (context, child) {
                return CertificationListPage();
              },
            );
          }
          return const SignInPage();
        },
      ),
    );
  }
}

