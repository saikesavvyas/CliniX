import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:clinix/localization/app_localizations.dart';
import 'package:clinix/localization_helper.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const CliniXApp(),
    ),
  );
}

// App State Management
class AppState with ChangeNotifier {
  Locale _locale = const Locale('en', 'US');
  UserRole _userRole = UserRole.user;
  bool _isDarkMode = false;
  String _currentUser = '';

  Locale get locale => _locale;
  UserRole get userRole => _userRole;
  bool get isDarkMode => _isDarkMode;
  String get currentUser => _currentUser;

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  void setUserRole(UserRole role) {
    _userRole = role;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setCurrentUser(String username) {
    _currentUser = username;
    notifyListeners();
  }
}

enum UserRole { admin, doctor, nurse, technician, user }

class CliniXApp extends StatelessWidget {
  const CliniXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'CliniX', // Don't use localization here yet
          debugShowCheckedModeBanner: false,
          theme: appState.isDarkMode
              ? ThemeData.dark().copyWith(
            primaryColor: Colors.teal,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              brightness: Brightness.dark,
            ),
          )
              : ThemeData(
            primarySwatch: Colors.teal,
            fontFamily: 'Roboto',
          ),
          locale: appState.locale,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('hi', 'IN'),
            Locale('ta', 'IN'),
            Locale('te', 'IN'),
            Locale('mr', 'IN'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          home: const SplashScreen(),
        );
      },
    );
  }
}

//
// ------------------- SPLASH SCREEN -------------------
//
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.7, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF006D77), Color(0xFF83C5BE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_hospital, size: 100, color: Colors.white),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)?.translate('appTitle') ?? 'CliniX',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)?.translate('slogan') ?? 'Engineered For Outages, Built For Lives!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//
// ------------------- ROLE SELECTION SCREEN -------------------
//
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF83C5BE), Color(0xFFEDF6F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_hospital, size: 60, color: Colors.teal),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)?.translate('selectRole') ?? 'Select Your Role',
                    style: TextStyle(
                      color: Colors.teal[900],
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _roleCard(context, Icons.admin_panel_settings, AppLocalizations.of(context)?.translate('admin') ?? 'Admin', UserRole.admin),
                          _roleCard(context, Icons.medical_services, AppLocalizations.of(context)?.translate('doctor') ?? 'Doctor', UserRole.doctor),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _roleCard(context, Icons.health_and_safety, AppLocalizations.of(context)?.translate('nurse') ?? 'Nurse', UserRole.nurse),
                          _roleCard(context, Icons.electrical_services, AppLocalizations.of(context)?.translate('technician') ?? 'Technician', UserRole.technician),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)?.translate('haveAccount') ?? 'Already have an account? Sign in',
                      style: const TextStyle(color: Colors.teal),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleCard(BuildContext context, IconData icon, String title, UserRole role) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Provider.of<AppState>(context, listen: false).setUserRole(role);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen(selectedRole: role)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: Colors.teal),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// ------------------- LOGIN SCREEN -------------------
//
class LoginScreen extends StatefulWidget {
  final UserRole? selectedRole;

  const LoginScreen({super.key, this.selectedRole});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.selectedRole;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF83C5BE), Color(0xFFEDF6F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Icon(Icons.local_hospital, size: 80, color: Colors.teal),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)?.translate('loginTitle') ?? 'CliniX Login',
                  style: TextStyle(
                    color: Colors.teal[900],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      DropdownButtonFormField<UserRole>(
                        value: _selectedRole,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          labelText: AppLocalizations.of(context)?.translate('role') ?? 'Role',
                          border: const OutlineInputBorder(),
                        ),
                        items: UserRole.values.map((UserRole role) {
                          return DropdownMenuItem<UserRole>(
                            value: role,
                            child: Text(_getRoleName(context, role)),
                          );
                        }).toList(),
                        onChanged: (UserRole? newValue) {
                          setState(() {
                            _selectedRole = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          hintText: AppLocalizations.of(context)?.translate('username') ?? 'Username',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          hintText: AppLocalizations.of(context)?.translate('password') ?? 'Password',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_selectedRole != null) {
                              appState.setUserRole(_selectedRole!);
                              appState.setCurrentUser(_usernameController.text);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const HomePage()),
                              );
                            }
                          },
                          icon: const Icon(Icons.arrow_forward, color: Colors.white),
                          label: Text(
                              AppLocalizations.of(context)?.translate('login') ?? 'LOG IN',
                              style: const TextStyle(color: Colors.white)
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          AppLocalizations.of(context)?.translate('forgotPassword') ?? 'Forgot password?',
                          style: const TextStyle(color: Colors.teal),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)?.translate('changeRole') ?? 'Change Role',
                          style: const TextStyle(color: Colors.teal),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRoleName(BuildContext context, UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppLocalizations.of(context)?.translate('admin') ?? 'Administrator';
      case UserRole.doctor:
        return AppLocalizations.of(context)?.translate('doctor') ?? 'Doctor';
      case UserRole.nurse:
        return AppLocalizations.of(context)?.translate('nurse') ?? 'Nurse';
      case UserRole.technician:
        return AppLocalizations.of(context)?.translate('technician') ?? 'Technician';
      case UserRole.user:
        return AppLocalizations.of(context)?.translate('user') ?? 'User';
    }
  }
}

//
// ------------------- HOME PAGE -------------------
//
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _screens = [
    const DashboardScreen(),
    const BatteryScreen(),
    const LogDataScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text([
          AppLocalizations.of(context)?.translate('dashboard') ?? 'Dashboard',
          AppLocalizations.of(context)?.translate('battery') ?? 'Battery',
          AppLocalizations.of(context)?.translate('logData') ?? 'Log Data'
        ][_selectedIndex]),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          )
        ],
      ),
      drawer: AppDrawer(userRole: appState.userRole, username: appState.currentUser),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard),
              label: AppLocalizations.of(context)?.translate('dashboard') ?? 'Dashboard'
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.battery_std),
              label: AppLocalizations.of(context)?.translate('battery') ?? 'Battery'
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              label: AppLocalizations.of(context)?.translate('logData') ?? 'Log Data'
          ),
        ],
      ),
    );
  }
}

//
// ------------------- APP DRAWER -------------------
//
class AppDrawer extends StatelessWidget {
  final UserRole userRole;
  final String username;

  const AppDrawer({super.key, required this.userRole, required this.username});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF006D77), Color(0xFF83C5BE)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30, color: Colors.teal),
                ),
                const SizedBox(height: 10),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _getRoleName(context, userRole),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(AppLocalizations.of(context)?.translate('dashboard') ?? 'Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.battery_full),
            title: Text(AppLocalizations.of(context)?.translate('battery') ?? 'Battery'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: Text(AppLocalizations.of(context)?.translate('logData') ?? 'Log Data'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          if (userRole == UserRole.admin || userRole == UserRole.technician)
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)?.translate('systemSettings') ?? 'System Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)?.translate('logout') ?? 'Logout'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getRoleName(BuildContext context, UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppLocalizations.of(context)?.translate('admin') ?? 'Administrator';
      case UserRole.doctor:
        return AppLocalizations.of(context)?.translate('doctor') ?? 'Doctor';
      case UserRole.nurse:
        return AppLocalizations.of(context)?.translate('nurse') ?? 'Nurse';
      case UserRole.technician:
        return AppLocalizations.of(context)?.translate('technician') ?? 'Technician';
      case UserRole.user:
        return AppLocalizations.of(context)?.translate('user') ?? 'User';
    }
  }
}

//
// ------------------- SETTINGS SCREEN -------------------
//
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<Map<String, dynamic>> _languageOptions = [
    {'locale': const Locale('en', 'US'), 'name': 'English', 'code': 'en_US'},
    {'locale': const Locale('hi', 'IN'), 'name': 'हिन्दी (Hindi)', 'code': 'hi_IN'},
    {'locale': const Locale('ta', 'IN'), 'name': 'தமிழ் (Tamil)', 'code': 'ta_IN'},
    {'locale': const Locale('te', 'IN'), 'name': 'తెలుగు (Telugu)', 'code': 'te_IN'},
    {'locale': const Locale('mr', 'IN'), 'name': 'मराठी (Marathi)', 'code': 'mr_IN'},
  ];

  String? _getCurrentLanguageCode(AppState appState) {
    return '${appState.locale.languageCode}_${appState.locale.countryCode}';
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentLanguageCode = _getCurrentLanguageCode(appState);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.translate('settings') ?? 'Settings'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.translate('appearance') ?? 'Appearance',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)?.translate('darkMode') ?? 'Dark Mode'),
                      Switch(
                        value: appState.isDarkMode,
                        onChanged: (value) {
                          appState.toggleTheme();
                        },
                        activeColor: Colors.teal,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.translate('language') ?? 'Language',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButton<String>(
                        value: currentLanguageCode,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: _languageOptions.map((Map<String, dynamic> option) {
                          return DropdownMenuItem<String>(
                            value: option['code'],
                            child: Text(option['name']),
                          );
                        }).toList(),
                        onChanged: (String? newLanguageCode) {
                          if (newLanguageCode != null) {
                            final selectedOption = _languageOptions.firstWhere(
                                  (option) => option['code'] == newLanguageCode,
                            );
                            appState.setLocale(selectedOption['locale']);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.translate('account') ?? 'Account',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(AppLocalizations.of(context)?.translate('editProfile') ?? 'Edit Profile'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: Text(AppLocalizations.of(context)?.translate('changePassword') ?? 'Change Password'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text(AppLocalizations.of(context)?.translate('notifications') ?? 'Notification Settings'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.translate('about') ?? 'About',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: Text(AppLocalizations.of(context)?.translate('appVersion') ?? 'App Version'),
                    subtitle: const Text('1.0.0'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: Text(AppLocalizations.of(context)?.translate('help') ?? 'Help & Support'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: Text(AppLocalizations.of(context)?.translate('privacy') ?? 'Privacy Policy'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
// ------------------- DASHBOARD -------------------
//
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  List<FlSpot> _generateDummyData() {
    return List.generate(
      12,
          (i) => FlSpot(i.toDouble(), (Random().nextDouble() * 50) + 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spots = _generateDummyData();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _infoCard(
          icon: Icons.electrical_services,
          title: AppLocalizations.of(context)?.translate('sourceInUse') ?? 'Source in Use',
          value: AppLocalizations.of(context)?.translate('grid') ?? 'Grid',
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.translate('voltage') ?? 'Voltage (V)',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          barWidth: 3,
                          color: Colors.teal,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: false),
                        ),
                      ],
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
                        bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${AppLocalizations.of(context)?.translate('updated') ?? 'Updated'}: 2025-09-11 12:45 PM',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoCard({required IconData icon, required String title, required String value}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.teal),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value, style: const TextStyle(fontSize: 20, color: Colors.black87)),
      ),
    );
  }
}

//
// ------------------- BATTERY SCREEN -------------------
//
class BatteryScreen extends StatelessWidget {
  const BatteryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _batteryCard(
            AppLocalizations.of(context)?.translate('batteryCharge') ?? 'Battery Charge',
            "82%",
            Icons.battery_charging_full
        ),
        const SizedBox(height: 16),
        _batteryCard(
            AppLocalizations.of(context)?.translate('backupTime') ?? 'Predicted Backup Time',
            "3 hrs 45 mins",
            Icons.access_time
        ),
        const SizedBox(height: 16),
        Text(
            AppLocalizations.of(context)?.translate('usageHistory') ?? 'Source Usage History',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: const [
              ListTile(title: Text('2025-09-11 11:05'), trailing: Text('Battery')),
              Divider(),
              ListTile(title: Text('2025-09-11 10:50'), trailing: Text('Grid')),
              Divider(),
              ListTile(title: Text('2025-09-11 10:00'), trailing: Text('Solar')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _batteryCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.teal),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value, style: const TextStyle(fontSize: 20, color: Colors.black87)),
      ),
    );
  }
}

//
// ------------------- LOG DATA SCREEN -------------------
//
class LogDataScreen extends StatelessWidget {
  const LogDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = [
      {"time": "2025-09-11 11:05", "user": "Sriram"},
      {"time": "2025-09-11 10:50", "user": "Ramesh"},
      {"time": "2025-09-11 10:00", "user": "Pradeesh"},
      {"time": "2025-09-10 18:45", "user": "Sashvi"},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (_, i) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: const Icon(Icons.person, color: Colors.teal),
            title: Text(logs[i]["time"]!, style: const TextStyle(fontSize: 16)),
            trailing: Text(logs[i]["user"]!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
        );
      },
    );
  }
}
