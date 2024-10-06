import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Bluetooth configuration for thermal printer device.
/// NOTE: Printer must be already paired with app running device. Otherwise printing won't work
class BluetoothConfiguration {
  /// Name of bluetooth printer device
  final String platformName;
  final String? advName;
  BluetoothConfiguration({
    required this.platformName,
    this.advName,
  });

  /// Transforms BluetoothDevice from flutter_blue_plus package to [BluetoothConfiguration]
  static Future<BluetoothConfiguration> fromBluetoothDevice(
      BluetoothDevice device) async {
    return BluetoothConfiguration(
      platformName: device.platformName,
      advName: device.advName,
    );
  }
}
