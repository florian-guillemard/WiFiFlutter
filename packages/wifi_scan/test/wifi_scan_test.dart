import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wifi_scan/wifi_scan.dart';

void main() {
  const channel = MethodChannel('wifi_scan');
  final mockHandlers = <String, Function(dynamic arguments)>{};

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) {
      final result = mockHandlers[call.method]?.call(call.arguments);
      if (result is Future) return result;
      return Future.value(result);
    });
  });

  tearDown(() {
    mockHandlers.clear();
    channel.setMockMethodCallHandler(null);
  });

  test('canStartScan', () async {
    final canCodes = [0, 1, 2, 3, 4, 5];
    final enumValues = [
      CanStartScan.notSupported,
      CanStartScan.yes,
      CanStartScan.noLocationPermissionRequired,
      CanStartScan.noLocationPermissionDenied,
      CanStartScan.noLocationPermissionUpgradeAccuracy,
      CanStartScan.noLocationServiceDisabled,
    ];
    for (int i = 0; i < canCodes.length; i++) {
      mockHandlers["canStartScan"] = (_) => canCodes[i];
      expect(await WiFiScan.instance.canStartScan(), enumValues[i]);
    }

    // -ve test
    final badCanCodes = [null, -1, 6, 7];
    for (int i = 0; i < badCanCodes.length; i++) {
      mockHandlers["canStartScan"] = (_) => badCanCodes[i];
      expect(() async => await WiFiScan.instance.canStartScan(),
          throwsUnsupportedError);
    }
  });

  test('startScan', () async {
    mockHandlers["startScan"] = (_) => true;
    expect(await WiFiScan.instance.startScan(), true);
  });

  test("canGetScannedNetworks", () async {
    final canCodes = [0, 1, 2, 3, 4, 5];
    final enumValues = [
      CanGetScannedNetworks.notSupported,
      CanGetScannedNetworks.yes,
      CanGetScannedNetworks.noLocationPermissionRequired,
      CanGetScannedNetworks.noLocationPermissionDenied,
      CanGetScannedNetworks.noLocationPermissionUpgradeAccuracy,
      CanGetScannedNetworks.noLocationServiceDisabled,
    ];
    for (int i = 0; i < canCodes.length; i++) {
      mockHandlers["canGetScannedNetworks"] = (_) => canCodes[i];
      expect(await WiFiScan.instance.canGetScannedNetworks(), enumValues[i]);
    }

    // -ve test
    final badCanCodes = [null, -1, 6, 7];
    for (int i = 0; i < badCanCodes.length; i++) {
      mockHandlers["canGetScannedNetworks"] = (_) => badCanCodes[i];
      expect(() async => await WiFiScan.instance.canGetScannedNetworks(),
          throwsUnsupportedError);
    }
  });

  test("scannedNetworks", () async {
    mockHandlers["scannedNetworks"] = (_) => [
          {
            "ssid": "my-ssid",
            "bssid": "00:00:00:12",
            "capabilities": "Unknown",
            "frequency": 600,
            "level": 5,
            "timestamp": null,
            "standard": null,
            "centerFrequency0": null,
            "centerFrequency1": null,
            "channelWidth": null,
            "isPasspoint": null,
            "operatorFriendlyName": null,
            "venueName": null,
            "is80211mcResponder": null,
          }
        ];
    final scannedNetworks = await WiFiScan.instance.scannedNetworks;
    expect(scannedNetworks.length, 1);
  });

  // TODO: firgure out way to mock EventChannel
  // test("scannedNetworksStream", () async {});
}
