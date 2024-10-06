/// Configuration of TCP/IP connection of printer connected to LAN
class TCPConfiguration {
  /// Internal IP address for printer device connected to LAN
  final String ipAddress;

  /// Printing port for printer. By default 9100
  final int port;

  /// Connecting to printer and printing timeout. 15 seconds by default
  final Duration printTimeout;

  TCPConfiguration({
    required this.ipAddress,
    this.port = 9100,
    this.printTimeout = const Duration(seconds: 15),
  });
}
