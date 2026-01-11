import 'package:flutter/material.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/auth/signup_screen.dart';
import '../presentation/auth/verify_otp_screen.dart';
import '../presentation/settings/settings.dart';
import '../presentation/emergency_alert/emergency_alert.dart';
import '../presentation/permission_setup/permission_setup.dart';
import '../presentation/safety_history/safety_history.dart';
import '../presentation/trusted_contacts_setup/trusted_contacts_setup.dart';
import '../presentation/safety_dashboard/safety_dashboard.dart';

class AppRoutes {
  // Auth routes
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verifyOtp = '/verify-otp';

  // App routes
  static const String initial = '/';
  static const String settings = '/settings';
  static const String emergencyAlert = '/emergency-alert';
  static const String permissionSetup = '/permission-setup';
  static const String safetyHistory = '/safety-history';
  static const String trustedContactsSetup = '/trusted-contacts-setup';
  static const String safetyDashboard = '/safety-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    verifyOtp: (context) => const VerifyOtpScreen(),
    settings: (context) => const Settings(),
    emergencyAlert: (context) => const EmergencyAlert(),
    permissionSetup: (context) => const PermissionSetup(),
    safetyHistory: (context) => const SafetyHistory(),
    trustedContactsSetup: (context) => const TrustedContactsSetup(),
    safetyDashboard: (context) => const SafetyDashboard(),
  };
}
