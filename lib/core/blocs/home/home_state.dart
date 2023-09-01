part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class LoadingHomeState extends HomeState {
  const LoadingHomeState();
}

class LoadedHomeState extends HomeState {
  final WeatherData item;
  final List<WeatherData> items;
  final List<LocationData>? cityList;

  const LoadedHomeState({required this.item, required this.items, this.cityList});

  @override
  List<Object?> get props => [item, items, cityList];

  LoadedHomeState copyWith({
    WeatherData? item,
    List<WeatherData>? items,
    List<LocationData>? cityList,
  }) {
    return LoadedHomeState(
      item: item ?? this.item,
      items: items ?? this.items,
      cityList: cityList ?? this.cityList,
    );
  }
}

class ErrorHomeState extends HomeState {
  final String? message;

  const ErrorHomeState(this.message);

  @override
  List<Object?> get props => [message];
}
