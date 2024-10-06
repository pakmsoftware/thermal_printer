library thermal_printer;

import 'dart:io';
import 'dart:typed_data';

import 'package:drago_usb_printer/drago_usb_printer.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thermal_printer/domain/models/bluetooth_configuration.dart';
import 'package:thermal_printer/domain/models/usb_configuration.dart';
import 'package:thermal_printer/domain/services/i_thermal_printer.dart';
import 'package:thermal_printer/utils/bluetooth_characteristic_extension.dart';
import 'package:thermal_printer/utils/list_extension.dart';
import 'package:thermal_printer/utils/log_util.dart';
import 'package:usb_serial/usb_serial.dart';

/// Thermal printer main class library containing all functionalities
class ThermalPrinter extends IThermalPrinter {
  ThermalPrinter({
    super.usbConfiguration,
    super.bluetoothConfiguration,
    super.tcpConfiguration,
  }) {
    _dragoUsbPrinter = DragoUsbPrinter();
  }

  late final DragoUsbPrinter _dragoUsbPrinter;

  /// Lists all USB devices connected to host
  /// Can be usefull to determine USB configuration for connected printer
  static Future<List<UsbConfiguration>> listUSBDevices() async {
    final devices = await UsbSerial.listDevices();
    return devices.map((e) => UsbConfiguration.fromUsbDevice(e)).toList();
  }

  /// Lists connected Bluetooth devices
  /// Can be useful to determine Bluetooth configuration for connected printer
  static Future<List<BluetoothConfiguration>>
      listConnectedBluetoothDevices() async {
    final devices = await FlutterBluePlus.bondedDevices;
    final List<BluetoothConfiguration> result = [];
    for (var device in devices) {
      final configToAdd =
          await BluetoothConfiguration.fromBluetoothDevice(device);
      result.add(configToAdd);
    }
    return result;
  }

  @override
  Future<bool> printByBluetooth({required Uint8List zplData}) async {
    try {
      if (bluetoothConfiguration == null) {
        throw Exception('You must provide bluetoothConfiguration!');
      }
      final scanPermission = await Permission.bluetoothScan.request();
      final connectPermission = await Permission.bluetoothConnect.request();
      if (!scanPermission.isGranted || !connectPermission.isGranted) {
        throw Exception('You must give Bluetooth permissions!');
      }

      final devices = await FlutterBluePlus.bondedDevices;
      final foundDevice = devices.firstWhereOrNull(
          (e) => e.platformName == bluetoothConfiguration?.platformName);
      if (foundDevice == null) {
        throw Exception(
          'Could not find device with name: ${bluetoothConfiguration?.platformName}',
        );
      }

      if (!foundDevice.isConnected) {
        await foundDevice.connect();
      }

      // Discover services and characteristics of the connected device
      final List<BluetoothService> services =
          await foundDevice.discoverServices();
      for (final BluetoothService service in services) {
        for (final BluetoothCharacteristic characteristic
            in service.characteristics) {
          // Find the correct characteristic and write the ZPL data to it
          if (characteristic.properties.write) {
            // https://developer.zebra.com/thread/36122 - file size limit per one GATT operation
            await characteristic.writeLarge(zplData, 23, timeout: 100);
            break; // Exit after sending the data
          }
        }
      }

      await foundDevice.disconnect();

      return true;
    } catch (e) {
      LogUtil.log(e.toString());
      return false;
    }
  }

  @override
  Future<bool> printByTCP({required Uint8List zplData}) async {
    try {
      if (tcpConfiguration == null) {
        throw Exception('You must provide tcpConfiguration!');
      }
      final host = tcpConfiguration?.ipAddress ?? '';
      final port = tcpConfiguration?.port ?? 9100;

      final socket = await Socket.connect(host, port);
      socket.add(zplData);
      // Close the socket after the data is sent
      await socket.flush();
      socket.destroy();

      return true;
    } catch (e) {
      LogUtil.log(e.toString());
      return false;
    }
  }

  @override
  Future<bool> printByUSB({required Uint8List zplData}) async {
    try {
      if (usbConfiguration == null) {
        throw Exception('You must provide usbConfiguration!');
      }
      await _dragoUsbPrinter.connect(
          usbConfiguration?.vendorId ?? -1, usbConfiguration?.productId ?? -1);

      await _dragoUsbPrinter.write(zplData);

      return true;
    } catch (e) {
      LogUtil.log(e.toString());
      return false;
    }
  }
}
