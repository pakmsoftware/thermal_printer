import 'dart:math';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

extension BluetoothCharacteristicExtension on BluetoothCharacteristic {
  /// Divides file [value] into chunks with [chunkSize] and sends divided data in chunks to characteristics by using write function
  Future<void> writeLarge(List<int> value, int chunkSize,
      {int timeout = 15}) async {
    final chunk = chunkSize - 3;
    for (int i = 0; i < value.length; i += chunk) {
      final List<int> subvalue = value.sublist(i, min(i + chunk, value.length));
      await write(
        subvalue,
        timeout: timeout,
      );
    }
  }
}
