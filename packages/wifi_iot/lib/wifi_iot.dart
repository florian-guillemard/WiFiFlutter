import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

enum WIFI_AP_STATE {
  WIFI_AP_STATE_DISABLING,
  WIFI_AP_STATE_DISABLED,
  WIFI_AP_STATE_ENABLING,
  WIFI_AP_STATE_ENABLED,
  WIFI_AP_STATE_FAILED
}

enum NetworkSecurity { WPA, WEP, NONE }

const MethodChannel _channel = const MethodChannel('wifi_iot');
const EventChannel _eventChannel =
    const EventChannel('plugins.wififlutter.io/wifi_scan');

class WiFiForIoTPlugin {
  /// Returns whether the WiFi AP is enabled or not
  @Deprecated(
      "This is will only work with < Android SDK 26. It could be made to work for >= Android SDK 29, request at https://github.com/alternadom/WiFiFlutter/issues/134.")
  static Future<bool> isWiFiAPEnabled() async {
    final Map<String, String> htArguments = Map();
    bool? bResult;
    try {
      bResult = await _channel.invokeMethod('isWiFiAPEnabled', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult != null && bResult;
  }

  /// Enable or Disable WiFi
  ///
  /// Wifi API changes for Android SDK >= 29, restricts certain behaviour:
  ///
  /// * Uses `startLocalOnlyHotspot` API to enable or disable WiFi AP.
  /// * This can only be used to communicate between co-located devices connected to the created WiFi Hotspot
  /// * The network created by this method will not have Internet access
  static void setWiFiAPEnabled(bool state) async {
    final Map<String, bool> htArguments = Map();
    htArguments["state"] = state;
    try {
      await _channel.invokeMethod('setWiFiAPEnabled', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
  }

  /// Request write permission
  static void showWritePermissionSettings(bool force) async {
    final Map<String, bool> htArguments = Map();
    htArguments["force"] = force;
    try {
      await _channel.invokeMethod('showWritePermissionSettings', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
  }

  /// Returns whether the WiFi AP is hidden or not
  @Deprecated(
      "This is will only work with < Android SDK 26. It could be made to work for >= Android SDK 29, request at https://github.com/alternadom/WiFiFlutter/issues/134.")
  static Future<bool> isWiFiAPSSIDHidden() async {
    final Map<String, String> htArguments = Map();
    bool? bResult;
    try {
      bResult = await _channel.invokeMethod('isSSIDHidden', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult != null && bResult;
  }

  /// Set whether the WiFi AP is hidden or not
  @Deprecated("This is will only work with < Android SDK 26.")
  static setWiFiAPSSIDHidden(bool hidden) async {
    final Map<String, bool> htArguments = Map();
    htArguments["hidden"] = hidden;
    try {
      await _channel.invokeMethod('setSSIDHidden', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
  }

  /// Returns the WiFi AP State
  ///
  /// ```
  /// 0 = WIFI_AP_STATE_DISABLING
  /// 1 = WIFI_AP_STATE_DISABLED
  /// 2 = WIFI_AP_STATE_ENABLING
  /// 3 = WIFI_AP_STATE_ENABLED
  /// 4 = WIFI_AP_STATE_FAILED
  /// ```
  @Deprecated("This is will only work with < Android SDK 26.")
  static Future<int?> getWiFiAPState() async {
    final Map<String, String> htArguments = Map();
    int? iResult;
    try {
      iResult = await _channel.invokeMethod('getWiFiAPState', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return iResult;
  }

  /// Get WiFi AP clients
  @Deprecated("This is will only work with < Android SDK 26.")
  static Future<List<APClient>> getClientList(
      bool onlyReachables, int reachableTimeout) async {
    final Map<String, Object> htArguments = Map();
    htArguments["onlyReachables"] = onlyReachables;
    htArguments["reachableTimeout"] = reachableTimeout;
    String? sResult;
    List<APClient> htResult = <APClient>[];
    try {
      sResult = await _channel.invokeMethod('getClientList', htArguments);
      htResult = APClient.parse(sResult!);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return htResult;
  }

  /// Set WiFi AP Configuaration
  @Deprecated("This is will only work with < Android SDK 26.")
  static void setWiFiAPConfiguration(Object poWiFiConfig) async {
    final Map<String, bool> htArguments = Map();
    htArguments["wifi_config"] = poWiFiConfig as bool;
    await _channel.invokeMethod('setWiFiAPConfiguration', htArguments);
  }

  /// Get WiFi AP SSID
  @Deprecated(
      "This is will only work with < Android SDK 26. It could be made to work for >= Android SDK 29, request at https://github.com/alternadom/WiFiFlutter/issues/134.")
  static Future<String?> getWiFiAPSSID() async {
    final Map<String, String> htArguments = Map();
    String? sResult;
    try {
      sResult = await _channel.invokeMethod('getWiFiAPSSID', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return sResult;
  }

  /// Set WiFi AP SSID
  @Deprecated("This is will only work with < Android SDK 26.")
  static setWiFiAPSSID(String psSSID) async {
    final Map<String, String> htArguments = Map();
    htArguments["ssid"] = psSSID;
    try {
      await _channel.invokeMethod('setWiFiAPSSID', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
  }

  /// Get WiFi AP's password
  @Deprecated(
      "This is will only work with < Android SDK 26. It could be made to work for >= Android SDK 29, request at https://github.com/alternadom/WiFiFlutter/issues/134.")
  static Future<String?> getWiFiAPPreSharedKey() async {
    final Map<String, String> htArguments = Map();
    String? sResult;
    try {
      sResult =
          await _channel.invokeMethod('getWiFiAPPreSharedKey', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return sResult;
  }

  /// Set WiFi AP password
  @Deprecated("This is will only work with < Android SDK 26.")
  static setWiFiAPPreSharedKey(String psPreSharedKey) async {
    final Map<String, String> htArguments = Map();
    htArguments["preSharedKey"] = psPreSharedKey;
    try {
      await _channel.invokeMethod('setWiFiAPPreSharedKey', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
  }

  static Stream<List<WifiNetwork>>? _onWifiScanResultReady;

  static Stream<List<WifiNetwork>> get onWifiScanResultReady {
    if (_onWifiScanResultReady == null) {
      _onWifiScanResultReady = _eventChannel
          .receiveBroadcastStream()
          .map((dynamic event) => WifiNetwork.parse(event));
    }
    return _onWifiScanResultReady!;
  }

  static Future<List<WifiNetwork>>? _loadWifiList() async {
    final Map<String, String> htArguments = Map();
    String? sResult;
    List<WifiNetwork> htResult = <WifiNetwork>[];
    try {
      sResult = await _channel.invokeMethod('loadWifiList', htArguments);
      htResult = WifiNetwork.parse(sResult!);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return htResult;
  }

  static Future<List<WifiNetwork>> loadWifiList() async {
    final List<WifiNetwork> result = (await _loadWifiList() ?? <WifiNetwork>[]);
    if (result.length >= 1) return result;

    result.clear();
    return await WiFiForIoTPlugin.onWifiScanResultReady.first;
  }

  static Future<bool?> forceWifiUsage(bool useWifi) async {
    final Map<String, bool> htArguments = Map();
    htArguments["useWifi"] = useWifi;
    try {
      return await _channel.invokeMethod('forceWifiUsage', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
  }

  /// Returns whether the WiFi is enabled
  static Future<bool> isEnabled() async {
    final Map<String, String> htArguments = Map();
    bool? bResult;
    try {
      bResult = await _channel.invokeMethod('isEnabled', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult != null && bResult;
  }

  /// Enable or Disable WiFi
  ///
  /// @param [shouldOpenSettings] only supports on android API level >= 29
  static setEnabled(bool state, {bool shouldOpenSettings = false}) async {
    final Map<String, bool> htArguments = Map();
    htArguments["state"] = state;
    htArguments["shouldOpenSettings"] = shouldOpenSettings;

    try {
      await _channel.invokeMethod('setEnabled', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
  }

  static Future<bool> connect(
    String ssid, {
    String? password,
    NetworkSecurity security = NetworkSecurity.NONE,
    bool joinOnce = true,
    bool withInternet = false,
    bool isHidden = false,
  }) async {
    if (!Platform.isIOS && !await isEnabled()) await setEnabled(true);
    bool? bResult;
    try {
      bResult = await _channel.invokeMethod('connect', {
        "ssid": ssid.toString(),
        "password": password.toString(),
        "join_once": joinOnce,
        "with_internet": withInternet,
        "is_hidden": isHidden,
        "security":
            security.toString().substring('$NetworkSecurity'.length + 1),
      });
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult != null && bResult;
  }

  static Future<bool> registerWifiNetwork(
    String ssid, {
    String? password,
    NetworkSecurity security = NetworkSecurity.NONE,
    bool isHidden = false,
  }) async {
    if (!Platform.isIOS && !await isEnabled()) await setEnabled(true);
    bool? bResult;
    try {
      await _channel.invokeMethod('registerWifiNetwork', {
        "ssid": ssid.toString(),
        "password": password.toString(),
        "security":
            security.toString().substring('$NetworkSecurity'.length + 1),
        "is_hidden": isHidden,
      });
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult != null && bResult;
  }

  static Future<bool> findAndConnect(String ssid,
      {String? password,
      bool joinOnce = true,
      bool withInternet = false}) async {
    if (!await isEnabled()) {
      await setEnabled(true);
    }
//    Map<String, Object> htArguments = Map();
//    htArguments["ssid"] = ssid;
//    htArguments["password"] = password;
//    if (joinOnce != null && isWep != null) {
//      htArguments["join_once"] = joinOnce;
//      htArguments["is_wep"] = isWep;
//    }
    bool? bResult;
    try {
      bResult = await _channel.invokeMethod('findAndConnect', {
        "ssid": ssid.toString(),
        "password": password.toString(),
        "join_once": joinOnce,
        "with_internet": withInternet,
      });
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult != null && bResult;
  }

  static Future<bool> isConnected() async {
    final Map<String, String> htArguments = Map();
    bool? bResult;
    try {
      bResult = await _channel.invokeMethod('isConnected', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult != null && bResult;
  }

  static disconnect() async {
    final Map<String, bool> htArguments = Map();
    try {
      await _channel.invokeMethod('disconnect', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
  }

  static Future<String?> getSSID() async {
    final Map<String, String> htArguments = Map();
    String? sResult;
    try {
      sResult = await _channel.invokeMethod('getSSID', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return sResult;
  }

  static Future<String?> getBSSID() async {
    final Map<String, String> htArguments = Map();
    String? sResult;
    try {
      sResult = await _channel.invokeMethod('getBSSID', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return sResult;
  }

  static Future<int?> getCurrentSignalStrength() async {
    final Map<String, String> htArguments = Map();
    int? iResult;
    try {
      iResult =
          await _channel.invokeMethod('getCurrentSignalStrength', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return iResult;
  }

  static Future<int?> getFrequency() async {
    final Map<String, String> htArguments = Map();
    int? iResult;
    try {
      iResult = await _channel.invokeMethod('getFrequency', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return iResult;
  }

  static Future<String?> getIP() async {
    final Map<String, String> htArguments = Map();
    String? sResult;
    try {
      sResult = await _channel.invokeMethod('getIP', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return sResult;
  }

  static Future<bool> removeWifiNetwork(String ssid) async {
    final Map<String, String> htArguments = Map();
    htArguments["ssid"] = ssid;
    bool? bResult;
    try {
      bResult = await _channel.invokeMethod('removeWifiNetwork', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    } on PlatformException catch (e) {
      print(e.message);
    }

    return bResult != null && bResult;
  }

  static Future<bool> isRegisteredWifiNetwork(String ssid) async {
    final Map<String, String> htArguments = Map();
    htArguments["ssid"] = ssid;
    bool? bResult;
    try {
      bResult =
          await _channel.invokeMethod('isRegisteredWifiNetwork', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult != null && bResult;
  }
}

class APClient {
  /// Returns the IP Address
  String? ipAddr;

  /// Returns the MAC Address
  String? hwAddr;

  /// Returns the device name
  String? device;

  /// Returns whether the AP client is reachable or not
  bool? isReachable;

  APClient.fromJson(Map<String, dynamic> json)
      : ipAddr = json['IPAddr'],
        hwAddr = json['HWAddr'],
        device = json['Device'],
        isReachable = json['isReachable'];

  Map<String, dynamic> toJson() => {
        'IPAddr': ipAddr,
        'HWAddr': hwAddr,
        'Device': device,
        'isReachable': isReachable,
      };

  static List<APClient> parse(String psString) {
    final List<APClient> htList = <APClient>[];

    final List<dynamic> htMapClients = json.decode(psString);

    htMapClients.forEach((htMapClient) {
      htList.add(APClient.fromJson(htMapClient));
    });

    return htList;
  }
}

class WifiNetwork {
  String? ssid;
  String? bssid;
  String? capabilities;
  int? frequency;
  int? level;
  int? timestamp;
  String? password;

  WifiNetwork.fromJson(Map<String, dynamic> json)
      : ssid = json['SSID'],
        bssid = json['BSSID'],
        capabilities = json['capabilities'],
        frequency = json['frequency'],
        level = json['level'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => {
        'SSID': ssid,
        'BSSID': bssid,
        'capabilities': capabilities,
        'frequency': frequency,
        'level': level,
        'timestamp': timestamp,
      };

  static List<WifiNetwork> parse(String psString) {
    /// [{"SSID":"Florian","BSSID":"30:7e:cb:8c:48:e4","capabilities":"[WPA-PSK-CCMP+TKIP][ESS]","frequency":2462,"level":-64,"timestamp":201307720907},{"SSID":"Pi3-AP","BSSID":"b8:27:eb:b1:fa:e1","capabilities":"[WPA2-PSK-CCMP][ESS]","frequency":2437,"level":-66,"timestamp":201307720892},{"SSID":"AlternaDom-SonOff","BSSID":"b8:27:eb:98:b4:81","capabilities":"[WPA2-PSK-CCMP][ESS]","frequency":2437,"level":-86,"timestamp":201307720897},{"SSID":"SFR_1CF0_2GEXT","BSSID":"9c:3d:cf:58:98:07","capabilities":"[WPA-PSK-CCMP+TKIP][WPA2-PSK-CCMP+TKIP][WPS][ESS]","frequency":2412,"level":-87,"timestamp":201307720887},{"SSID":"Freebox-5CC952","BSSID":"f4:ca:e5:96:71:c4","capabilities":"[WPA-PSK-CCMP][ESS]","frequency":2442,"level":-90,"timestamp":201307720902}]

    final List<WifiNetwork> htList = <WifiNetwork>[];

    try {
      final List<dynamic> htMapNetworks = json.decode(psString);

      htMapNetworks.forEach((htMapNetwork) {
        htList.add(WifiNetwork.fromJson(htMapNetwork));
      });
    } on FormatException catch (e) {
      print("FormatException : ${e.toString()}");
      print("psString = '$psString'");
    }
    return htList;
  }
}
