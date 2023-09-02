import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/repositories/weather_repository.dart';
import 'package:weather_app/core/service/weather_service.dart';
import 'package:weather_app/models/city_data.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/utils/debouncer.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final IWeatherRepository _weatherRepository;
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  HomeBloc({IWeatherRepository? weatherRepository})
      : super(LoadedHomeState(item: WeatherData(), items: const [])) {
    final dio = Dio();
    _weatherRepository = weatherRepository ?? WeatherRepository(WeatherService(dio));

    on<GetCurrentLocationEvent>(_getCurrentLocation);
    on<GetListCityEvent>(_getListCityEvent);
    on<GetWeatherCityName>(_getWeatherCityNameEvent);
    on<AddListCityEvent>(_addListCityEvent);
  }

  FutureOr<void> _getCurrentLocation(GetCurrentLocationEvent event, Emitter<HomeState> emit) async {
    emit(const LoadingHomeState());
    emit(LoadedHomeState(
        item: await _weatherRepository.getCurrentWeather(''),
        items: await _weatherRepository.getForecastWeather('')));
  }

  FutureOr<void> _addListCityEvent(AddListCityEvent event, Emitter<HomeState> emit) async {
    final currentState = state;
    if (currentState is LoadedHomeState) {
      emit(currentState.copyWith(cityList: event.cityName));
    }
  }

  FutureOr<void> _getWeatherCityNameEvent(GetWeatherCityName event, Emitter<HomeState> emit) async {
    emit(const LoadingHomeState());
    emit(LoadedHomeState(
        item: await _weatherRepository.getCurrentWeather(event.cityName),
        items: await _weatherRepository.getForecastWeather(event.cityName)));
  }

  FutureOr<void> _getListCityEvent(GetListCityEvent event, Emitter<HomeState> emit) async {
    List<LocationData> similarCities = [];

    await _debouncer.run(() async {
      final jsonString = await rootBundle.loadString('lib/assets/city.list.json');
      final jsonData = json.decode(jsonString);

      if (jsonData is List) {
        for (final cityData in jsonData) {
          final locationData = LocationData.fromJson(cityData);
          final cityNameLower = locationData.name?.toLowerCase() ?? "";
          if (cityNameLower.contains(event.cityName.toLowerCase())) {
            similarCities.add(locationData);
            if (similarCities.length >= 5) {
              break;
            }
          }
        }
      }
      add(AddListCityEvent(similarCities));
    });
  }
}
