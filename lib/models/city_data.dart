import 'package:equatable/equatable.dart';

class LocationData extends Equatable {
  final num? id;
  final String? name;
  final String? state;
  final String? country;
  final Coord? coord;

  const LocationData({
    this.id,
    this.name,
    this.state,
    this.country,
    this.coord,
  });

  @override
  List<Object?> get props => [id, name, state, country, coord];

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      id: json['id'],
      name: json['name'],
      state: json['state'],
      country: json['country'],
      coord: json['coord'] != null ? Coord.fromJson(json['coord']) : null,
    );
  }

  LocationData copyWith({
    num? id,
    String? name,
    String? state,
    String? country,
    Coord? coord,
  }) {
    return LocationData(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      country: country ?? this.country,
      coord: coord ?? this.coord,
    );
  }
}

class Coord extends Equatable {
  final double? lon;
  final double? lat;

  const Coord({
    this.lon,
    this.lat,
  });

  @override
  List<Object?> get props => [lon, lat];

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lon: json['lon'],
      lat: json['lat'],
    );
  }
}
