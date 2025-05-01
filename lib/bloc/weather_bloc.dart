import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_learning/services/weather_service.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService service;

  WeatherBloc(this.service) : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await service.getWeather(event.cityName);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError("Could not fetch weather"));
      }
    });
  }
}
