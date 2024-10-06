import 'dart:typed_data';

import 'package:thermal_printer/domain/models/bluetooth_configuration.dart';
import 'package:thermal_printer/domain/models/tcp_configuration.dart';
import 'package:thermal_printer/domain/models/usb_configuration.dart';

/// Main interface for thermal printer library
abstract class IThermalPrinter {
  /// Configuration for USB connection. Must be provided when printing by USB
  final UsbConfiguration? usbConfiguration;

  /// Configuration for Bluetooth connection. Must be provided when printing by Bluetooth
  final BluetoothConfiguration? bluetoothConfiguration;

  /// Configuration for TCP/IP connection. Must be provided when printing by Ethernet cable or WiFi to LAN
  final TCPConfiguration? tcpConfiguration;

  IThermalPrinter({
    this.usbConfiguration,
    this.bluetoothConfiguration,
    this.tcpConfiguration,
  });

  /// Prints provided [zplData] zpl file in thermal printer by USB connection
  /// [zplData] must be valid ZPL file configured properly by label size and dpi\
  /// Returns true if [zplData] was sent succesfully to the printer
  /// Tested with Zebra ZD421 printer
  Future<bool> printByUSB({required Uint8List zplData});

  /// Prints provided [zplData] zpl file in thermal printer by Bluetooth connection
  /// Printed must be already paired with host device and have correct MAC address provided in
  /// [zplData] must be valid ZPL file configured properly by label size and dpi\
  /// Returns true if [zplData] was sent succesfully to the printer
  /// Tested with Zebra ZD421 printer
  Future<bool> printByBluetooth({required Uint8List zplData});

  /// Prints provided [zplData] zpl file in thermal printer by TCP/IP
  /// Printer must be connected to the same network and have proper IP and port addresses provided in
  /// [zplData] must be valid ZPL file configured properly by label size and dpi\
  /// Returns true if [zplData] was sent succesfully to the printer
  /// Tested with Zebra ZD421 printer
  Future<bool> printByTCP({required Uint8List zplData});
}
