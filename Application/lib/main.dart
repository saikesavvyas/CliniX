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
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  String role = 'Doctor';
  final List<String> roles = ['Administrator', 'Doctor', 'Nurse', 'Technician'];

  late AnimationController _animationController;
  late Animation<Color?> _gradientAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: 6))
      ..repeat(reverse: true);

    _gradientAnimation = ColorTween(
      begin: const Color(0xFF009688),
      end: const Color(0xFF4DB6AC),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _gradientAnimation.value ?? const Color(0xFF009688),
                      const Color(0xFFB2DFDB),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                top: 60,
                left: 30,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(Icons.local_hospital, size: 120, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 80,
                right: 20,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(Icons.healing, size: 100, color: Colors.white),
                ),
              ),
              Positioned(
                top: 180,
                right: 50,
                child: Opacity(
                  opacity: 0.05,
                  child: Icon(Icons.favorite, size: 140, color: Colors.white),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00796B),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildTextField(
                              controller: usernameController,
                              label: 'Username',
                              icon: Icons.person,
                              validator: (value) =>
                              value!.isEmpty ? 'Enter username' : null),
                          const SizedBox(height: 16),
                          _buildDropdown(),
                          const SizedBox(height: 16),
                          _buildTextField(
                              controller: phoneController,
                              label: 'Phone Number',
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              validator: (value) =>
                              value!.isEmpty ? 'Enter phone number' : null),
                          const SizedBox(height: 16),
                          _buildTextField(
                              controller: passwordController,
                              label: 'Password',
                              icon: Icons.lock,
                              obscureText: true,
                              validator: (value) => value!.length < 6
                                  ? 'Minimum 6 characters'
                                  : null),
                          const SizedBox(height: 16),
                          _buildTextField(
                              controller: confirmPasswordController,
                              label: 'Confirm Password',
                              icon: Icons.lock_outline,
                              obscureText: true,
                              validator: (value) => value !=
                                  passwordController.text
                                  ? 'Passwords do not match'
                                  : null),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF00796B),
                                      Color(0xFF004D40),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Already have an account? Log in',
                              style: TextStyle(color: Color(0xFF00796B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF00796B)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: role,
      decoration: InputDecoration(
        labelText: 'Role',
        prefixIcon: const Icon(Icons.work, color: Color(0xFF00796B)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: Colors.white,
      ),
      items: roles
          .map((r) => DropdownMenuItem(
        value: r,
        child: Text(r),
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          role = value!;
        });
      },
    );
  }
}

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
          title: 'CliniX',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)?.translate('haveAccount') ?? 'Do not have an account? Sign in',
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

class LoginScreen extends StatefulWidget {
  final UserRole? selectedRole;

  const LoginScreen({super.key, this.selectedRole});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _clinicIdController = TextEditingController();

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
                          labelText: AppLocalizations.of(context)?.translate('Role') ?? 'Role',
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _clinicIdController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.badge),
                          hintText: AppLocalizations.of(context)?.translate('clinicId') ?? 'Clinic ID',
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
  title: AppLocalizations.of(context)
      ?.translate('sourceInUse') ??
  'Source in Use',
  value: AppLocalizations.of(context)?.translate('grid') ?? 'Grid',
  ),
  const SizedBox(height: 16),
  Card(
  elevation: 4,
  shape:
  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  child: Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(
  AppLocalizations.of(context)?.translate('voltage') ??
  'Voltage (V)',
  style: const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  ),
  ),
  SizedBox(
  height: 200,
  child: LineChart(
  LineChartData(
  minX: 0,
  maxX: 11,
  minY: 200,
  maxY: 250,
  gridData: FlGridData(
  show: true,
  drawVerticalLine: true,
  getDrawingHorizontalLine: (value) => FlLine(
  color: Colors.grey.withOpacity(0.2),
  strokeWidth: 1,
  ),
  getDrawingVerticalLine: (value) => FlLine(
  color: Colors.grey.withOpacity(0.2),
  strokeWidth: 1,
  ),
  ),
  borderData: FlBorderData(
  show: true,
  border: Border.all(color: Colors.grey.withOpacity(0.3)),
  ),
  titlesData: FlTitlesData(
  leftTitles: AxisTitles(
  sideTitles: SideTitles(
  showTitles: true,
  reservedSize: 40,
  interval: 10,
  getTitlesWidget: (value, meta) {
  if (value % 10 == 0) {
  return Text(
  value.toInt().toString(),
  style: TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w500,
  color: Colors.blueGrey[700],
  ),
  );
  }
  return Container();
  },
  ),
  ),
  bottomTitles: AxisTitles(
  sideTitles: SideTitles(
  showTitles: true,
  interval: 2,
  getTitlesWidget: (value, meta) {
  return Padding(
  padding: const EdgeInsets.only(top: 8.0),
  child: Text(
  value.toInt().toString(),
  style: TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w500,
  color: Colors.blueGrey[700],
  ),
  ),
  );
  },
  ),
  ),
  topTitles:
  AxisTitles(sideTitles: SideTitles(showTitles: false)),
  rightTitles:
  AxisTitles(sideTitles: SideTitles(showTitles: false)),
  ),
  lineBarsData: [
  LineChartBarData(
  spots: spots,
  isCurved: true,
  gradient: const LinearGradient(
  colors: [Colors.teal, Colors.deepPurpleAccent],
  ),
  barWidth: 3,
  isStrokeCapRound: true,
  belowBarData: BarAreaData(
  show: true,
  gradient: LinearGradient(
  colors: [
  Colors.teal.withOpacity(0.3),
  Colors.deepPurpleAccent.withOpacity(0.1),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  ),
  ),
  dotData: FlDotData(
  show: true,
  getDotPainter: (spot, percent, bar, index) =>
  FlDotCirclePainter(
  radius: 4,
  color: Colors.white,
  strokeWidth: 2,
  strokeColor: Colors.deepPurpleAccent,
  ),
  ),
  ),
  ],
  lineTouchData: LineTouchData(
  enabled: true,
  handleBuiltInTouches: true,
  touchTooltipData: LineTouchTooltipData(
  tooltipBgColor: Colors.black87,
  tooltipRoundedRadius: 8,
  getTooltipItems: (touchedSpots) {
  return touchedSpots.map((spot) {
  return LineTooltipItem(
  'X: ${spot.x.toInt()}\nY: ${spot.y.toStringAsFixed(1)} V',
  const TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 12,
  ),
  );
  }).toList();
  },
  ),
  getTouchedSpotIndicator: (barData, spotIndexes) {
  return spotIndexes.map((index) {
  return TouchedSpotIndicatorData(
  FlLine(
  color:
  Colors.deepPurpleAccent.withOpacity(0.6),
  strokeWidth: 1.5,
  dashArray: [5, 5],
  ),
  FlDotData(
  show: true,
  getDotPainter:
  (spot, percent, bar, index) =>
  FlDotCirclePainter(
  radius: 6,
  color: Colors.white,
  strokeWidth: 3,
  strokeColor: Colors.deepPurpleAccent,
  ),
  ),
  );
  }).toList();
  },
  ),
  ),
  duration: const Duration(milliseconds: 800),
  curve: Curves.easeOutCubic,
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

  Widget _infoCard(
  {required IconData icon,
  required String title,
  required String value}) {
  return Card(
  elevation: 4,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  child: ListTile(
  leading: Icon(icon, size: 40, color: Colors.teal),
  title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
  subtitle: Text(value,
  style: const TextStyle(fontSize: 20, color: Colors.black87)),
  ),
  );
  }
  }

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


