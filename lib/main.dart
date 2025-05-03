import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'bloc/weather_bloc.dart';
import 'bloc/weather_event.dart';
import 'bloc/weather_state.dart';
import 'services/weather_service.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather BLoC App',
      home: BlocProvider(
        create: (_) => WeatherBloc(WeatherService()),
        child: const WeatherPage(),
      ),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();

  void _search() {
    final city = _controller.text;
    context.read<WeatherBloc>().add(FetchWeather(city));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter city',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _search, child: const Text('Search')),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherLoaded) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.weather.city,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${state.weather.temperature} °C',
                          style: const TextStyle(fontSize: 36),
                        ),
                      ],
                    );
                  } else if (state is WeatherError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(
                    child: Text('Enter a city to get weather'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
