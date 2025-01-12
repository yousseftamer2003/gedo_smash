// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/controllers/business_setup_controller.dart';
import 'package:food2go_app/controllers/lang_services_controller.dart';
import 'package:food2go_app/models/business_setup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food2go_app/view/screens/onboarding_screens/onboarding.dart';

class LogoOnboarding extends StatefulWidget {
  const LogoOnboarding({super.key});

  @override
  State<LogoOnboarding> createState() => _LogoOnboardingState();
}

class _LogoOnboardingState extends State<LogoOnboarding> {
  @override
  void initState() {
    super.initState();
    Provider.of<LangServices>(context, listen: false).loadLangFromPrefs();
    _navigateToNextScreen();
  }

  BusinessSetup? businessSetup;

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final isNewUser = prefs.getBool('isNewUser') ?? true;
    Provider.of<BusinessSetupController>(context, listen: false)
        .fetchBusinessSetup(context);

    Future.delayed(
      const Duration(seconds: 5),
      () {
        businessSetup =
            Provider.of<BusinessSetupController>(context, listen: false)
                .businessSetup;
        if (isNewUser) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Onboarding(),
            ),
          );
        } else {
          Provider.of<LoginProvider>(context, listen: false).checkToken(
              context, businessSetup!.login, businessSetup!.loginDelivery);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/smashgedo.png',
          width: 2000,
          height: 2000,
        ),
      ),
    );
  }
}
