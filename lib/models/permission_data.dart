import 'package:equatable/equatable.dart';

class PermissionData extends Equatable {
  final bool hasPermission;
  final String permissionText;

  const PermissionData({required this.hasPermission, required this.permissionText});

  @override
  List<Object?> get props => [hasPermission, permissionText];
}
