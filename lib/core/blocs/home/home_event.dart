part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class GetCurrentLocationEvent extends HomeEvent {
  const GetCurrentLocationEvent();
}

class GetListCityEvent extends HomeEvent {
  final String cityName;
  const GetListCityEvent(this.cityName);
}

class GetWeatherCityName extends HomeEvent {
  final String cityName;
  const GetWeatherCityName(this.cityName);
}

class AddListCityEvent extends HomeEvent {
  final List<LocationData> cityName;
  const AddListCityEvent(this.cityName);
}

class UpdateMarketItemsEvent extends HomeEvent {
  // final List<Instrument> items;
  //
  // const UpdateMarketItemsEvent({required this.items});
}

class StopUpdateMarketItemsEvent extends HomeEvent {
  const StopUpdateMarketItemsEvent();
}
