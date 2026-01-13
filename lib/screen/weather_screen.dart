import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  late Future<Weather> weatherFuture;
  bool isFirstLoad = true;

  // Coffee Palette Colors
  final Color espresso = const Color(0xFF3C2A21);
  final Color coffee = const Color(0xFF6F4E37);
  final Color latte = const Color(0xFFA67B5B);
  final Color cream = const Color(0xFFFFF9F5);
  final Color milkFoam = const Color(0xFFFCF5ED);

  @override
  void initState() {
    super.initState();
    weatherFuture = WeatherService.getWeather('Manila');
  }

  // Helper function to get formatted date and time
  String _getFormattedDate() {
    final now = DateTime.now();
    final List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final List<String> days = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];

    // Format: "Tue, Jan 13 | 10:30 AM"
    String day = days[now.weekday - 1];
    String month = months[now.month - 1];
    String hour = (now.hour % 12 == 0 ? 12 : now.hour % 12).toString();
    String minute = now.minute.toString().padLeft(2, '0');
    String period = now.hour >= 12 ? 'PM' : 'AM';

    return '$day, $month ${now.day} | $hour:$minute $period';
  }

  void _searchWeather() {
    final String city = _cityController.text.trim();
    if (city.isEmpty) {
      _showSnackBar('Please enter a city name', Colors.orange);
      return;
    }
    setState(() {
      weatherFuture = WeatherService.getWeather(city);
      isFirstLoad = false;
    });
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: cream)),
        backgroundColor: espresso,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: milkFoam,
      appBar: AppBar(
        title: const Text('WEATHER',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: espresso,
        foregroundColor: cream,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ===== SEARCH SECTION =====
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    cursorColor: coffee,
                    decoration: InputDecoration(
                      hintText: 'Search city...',
                      prefixIcon: Icon(Icons.coffee, color: coffee),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: latte),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: coffee, width: 2),
                      ),
                    ),
                    onSubmitted: (_) => _searchWeather(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchWeather,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: coffee,
                    foregroundColor: cream,
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // ===== WEATHER CARD SECTION =====
            FutureBuilder<Weather>(
              future: weatherFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: coffee));
                }

                if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      snapshot.error.toString().replaceFirst('Exception: ', ''),
                      style: TextStyle(color: espresso),
                    ),
                  );
                }

                if (snapshot.hasData) {
                  final weather = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [espresso, coffee],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: coffee.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        // --- Added Date & Time Text ---
                        Text(
                          _getFormattedDate(),
                          style: TextStyle(
                            fontSize: 14,
                            color: latte,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          weather.city.toUpperCase(),
                          style: TextStyle(
                            fontSize: 22,
                            letterSpacing: 4,
                            fontWeight: FontWeight.bold,
                            color: cream,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${weather.temperature.toStringAsFixed(1)}°',
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: cream,
                          ),
                        ),
                        Text(
                          weather.description.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2,
                            color: milkFoam.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          height: 1,
                          width: 100,
                          color: latte.withOpacity(0.5),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            WeatherInfoCard(
                              icon: Icons.water_drop_outlined,
                              label: 'HUMIDITY',
                              value: '${weather.humidity}%',
                              color: cream,
                            ),
                            WeatherInfoCard(
                              icon: Icons.air_rounded,
                              label: 'WIND',
                              value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                              color: cream,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const Text('Start your morning with weather...');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const WeatherInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: color.withOpacity(0.6), fontSize: 10, letterSpacing: 1),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}