import 'package:flutter/material.dart';
import 'package:clinix/localization/app_localizations.dart';

String translate(BuildContext context, String key) {
  try {
    return AppLocalizations.of(context).translate(key);
  } catch (e) {
    final defaultTranslations = {
      'appTitle': 'CliniX',
      'slogan': 'Engineered For Outages, Built For Lives!',
      'selectRole': 'Select Your Role',
      'admin': 'Administrator',
      'doctor': 'Doctor',
      'nurse': 'Nurse',
      'technician': 'Technician',
      'user': 'User',
      'loginTitle': 'CliniX Login',
      'username': 'Username',
      'password': 'Password',
      'login': 'LOG IN',
      'forgotPassword': 'Forgot password?',
      'changeRole': 'Change Role',
      'haveAccount': 'Already have an account? Sign in',
      'dashboard': 'Dashboard',
      'battery': 'Battery',
      'logData': 'Log Data',
      'settings': 'Settings',
      'logout': 'Logout',
      'systemSettings': 'System Settings',
      'sourceInUse': 'Source in Use',
      'grid': 'Grid',
      'voltage': 'Voltage (V)',
      'updated': 'Updated',
      'batteryCharge': 'Battery Charge',
      'backupTime': 'Predicted Backup Time',
      'usageHistory': 'Source Usage History',
      'appearance': 'Appearance',
      'darkMode': 'Dark Mode',
      'language': 'Language',
      'account': 'Account',
      'editProfile': 'Edit Profile',
      'changePassword': 'Change Password',
      'notifications': 'Notification Settings',
      'about': 'About',
      'appVersion': 'App Version',
      'help': 'Help & Support',
      'privacy': 'Privacy Policy',
    };
    return defaultTranslations[key] ?? key;
  }

}
