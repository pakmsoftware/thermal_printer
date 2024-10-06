import 'package:usb_serial/usb_serial.dart';

/// Configuration for USB connection of thermal printer.
class UsbConfiguration {
  /// Optional: Name of manufacter name of printer
  String? manufacterName;

  /// Optional: Name of device name of printer
  String? deviceName;

  /// Optional: USB serial of printer
  String? serial;

  /// Optional: ID of printer
  int? deviceId;

  /// Vendor ID
  final int vendorId;

  /// Product ID
  final int productId;

  UsbConfiguration({
    required this.vendorId,
    required this.productId,
    this.deviceName,
    this.manufacterName,
    this.deviceId,
    this.serial,
  });

  /// Transforms [device] from UsbSerial package to UsbConfiguration
  factory UsbConfiguration.fromUsbDevice(UsbDevice device) {
    return UsbConfiguration(
      vendorId: device.vid ?? -1,
      productId: device.pid ?? -1,
      deviceName: device.manufacturerName,
      manufacterName: device.manufacturerName,
      serial: device.serial,
      deviceId: device.deviceId,
    );
  }
}
