import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/mqtt_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MQTTService(),
      child: const CliniXApp(),
    ),
  );
}

class CliniXApp extends StatelessWidget {
  const CliniXApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttService = Provider.of<MQTTService>(context, listen: false);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mqttService.connect();
    });

    return MaterialApp(
      title: 'CliniX',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset('assets/clinixicon2.png', height: 100),
            ),
            const SizedBox(height: 20),
            const Text(
              'CliniX',
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Engineered For Outages, Built For Lives!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundPainter(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.power_settings_new, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    'CliniX Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const HomePage()),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward, color: Colors.white),
                            label: const Text('LOG IN', style: TextStyle(color: Colors.white)),
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
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.teal),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF006D77), Color(0xFF83C5BE)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.25,
        size.width * 0.5,
        size.height * 0.3,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.35,
        size.width,
        size.height * 0.3,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(['Dashboard', 'Battery', 'Log Data'][_selectedIndex])),
      drawer: const AppDrawer(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.battery_std), label: 'Battery'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Log Data'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.battery_std),
            title: const Text('Battery'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Log Data'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  List<FlSpot> _generateChartData(List<double> voltageData) {
    List<FlSpot> spots = [];
    for (int i = 0; i < voltageData.length; i++) {
      spots.add(FlSpot(i.toDouble(), voltageData[i]));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final mqttService = Provider.of<MQTTService>(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 4,
          child: ListTile(
            leading: const Icon(Icons.electrical_services, size: 40),
            title: const Text('Source in Use:'),
            subtitle: Text(
              mqttService.currentSource,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Voltage (V)', style: TextStyle(fontSize: 18)),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: _generateChartData(mqttService.voltageData),
                          isCurved: true,
                          barWidth: 3,
                          color: Colors.teal,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              final voltage = spot.y;
                              Color dotColor;

                              if (voltage < 210) {
                                dotColor = Colors.red;
                              } else if (voltage < 230) {
                                dotColor = Colors.orange;
                              } else {
                                dotColor = Colors.green;
                              }

                              return FlDotCirclePainter(
                                radius: 4,
                                color: dotColor,
                                strokeWidth: 1.5,
                                strokeColor: Colors.black,
                              );
                            },
                          ),
                        ),
                      ],
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current: ${mqttService.currentVoltage.toStringAsFixed(1)} V',
                  style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class BatteryScreen extends StatelessWidget {
  const BatteryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttService = Provider.of<MQTTService>(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 4,
          child: ListTile(
            leading: const Icon(Icons.battery_charging_full, size: 40),
            title: const Text('Battery Charge:'),
            subtitle: Text(
              '${mqttService.batteryLevel}%',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          child: ListTile(
            leading: const Icon(Icons.access_time, size: 40),
            title: const Text('Predicted Backup Time'),
            subtitle: Text(
              '${mqttService.backupTime} mins',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Source Usage History', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          child: Column(
            children: const [
              ListTile(title: Text('2025-08-03 11:05'), trailing: Text('Battery')),
              Divider(),
              ListTile(title: Text('2025-08-03 10:50'), trailing: Text('Grid')),
              Divider(),
              ListTile(title: Text('2025-08-03 10:00'), trailing: Text('Solar')),
            ],
          ),
        )
      ],
    );
  }
}

class LogDataScreen extends StatelessWidget {
  const LogDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(title: Text('2025-08-03 11:05'), trailing: Text('Battery')),
        Divider(),
        ListTile(title: Text('2025-08-03 10:50'), trailing: Text('Grid')),
        Divider(),
        ListTile(title: Text('2025-08-03 10:00'), trailing: Text('Solar')),
        Divider(),
        ListTile(title: Text('2025-08-02 18:45'), trailing: Text('Generator')),
      ],
    );
  }
}
