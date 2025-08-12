import 'package:flutter/material.dart';
import 'package:namer_app/services/auth_service.dart';
import 'package:namer_app/services/location_service.dart';
import 'package:namer_app/services/weather_service.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  LocationResult? location;
  Weather? weather;
  TemperatureScaleTypes scale = TemperatureScaleTypes.celsius;

  @override
  void initState() {
    super.initState();
    initLocationAndTemperature();
  }

  void initLocationAndTemperature() async {
    await _getCurrentLocation();
    if (location?.status == PermissionStatus.allowed) {
      _fetchTemperature(
          location?.latitude as double, location?.longitude as double);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = weather;
    AbstractTemperatureScale currentScale;
    AbstractTemperatureScale altScale;
    if (scale == TemperatureScaleTypes.celsius) {
      currentScale = CelsiusScale();
      altScale = FahrenheitScale();
    } else {
      currentScale = FahrenheitScale();
      altScale = CelsiusScale();
    }

    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = constraints.maxWidth >= 600;
      return Scaffold(
        body: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              SizedBox(
                width: isDesktop ? 600 : 320,
                height: isDesktop ? 300 : 400,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: location == null
                        ? WeatherSkeleton()
                        : location?.status != PermissionStatus.allowed
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.warning,
                                      size: 50,
                                      color: Theme.of(context).primaryColor),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                        location?.status ==
                                                PermissionStatus.disabled
                                            ? 'Location Disabled'
                                            : 'Location Permission Denied',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true),
                                  ),
                                ],
                              )
                            : w == null
                                ? WeatherSkeleton()
                                : Flex(
                                    spacing: 15,
                                    direction: isDesktop
                                        ? Axis.horizontal
                                        : Axis.vertical,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        w.icon,
                                        width: 72,
                                        height: 72,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${currentScale.kelvinToScale(w.temperature).round()} ${currentScale.unit}',
                                                style: const TextStyle(
                                                  fontSize: 42,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Column(
                                                children: [
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      minimumSize: Size.zero,
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        scale = scale ==
                                                                TemperatureScaleTypes
                                                                    .celsius
                                                            ? TemperatureScaleTypes
                                                                .fahrenheit
                                                            : TemperatureScaleTypes
                                                                .celsius;
                                                      });
                                                    },
                                                    child: Text(
                                                      altScale.unit,
                                                      style: const TextStyle(
                                                        fontSize: 22,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Text(
                                            w.name,
                                            style: const TextStyle(
                                              fontSize: 28,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        w.cityName,
                                        style: const TextStyle(
                                          fontSize: 28,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () => AuthService().signOut(),
                  child: Text('Logout')),
            ],
          ),
        )),
      );
    });
  }

  Future<void> _getCurrentLocation() async {
    final loc = await LocationService().getCurrentLocation();
    setState(() {
      location = loc;
    });
  }

  void _fetchTemperature(double latitude, double longitude) async {
    try {
      final w = await WeatherService().fetchTemperature(latitude, longitude);
      setState(() {
        weather = w;
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}

class WeatherSkeleton extends StatefulWidget {
  @override
  State<WeatherSkeleton> createState() => _WeatherSkeletonState();
}

class _WeatherSkeletonState extends State<WeatherSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnim;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);

    _colorAnim = ColorTween(
      begin: Colors.grey[300],
      end: Colors.grey[100],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnim,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _colorAnim.value,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _colorAnim.value,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _colorAnim.value,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
