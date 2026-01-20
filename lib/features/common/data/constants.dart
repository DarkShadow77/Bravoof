import 'dart:convert';
import 'dart:math';

import 'package:Bravoo/session/session_manager.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Constants {
  static final sessionManager = SessionManager();
  final storage = FlutterSecureStorage();
  // Android options for key management
  AndroidOptions _getAndroidOptions(String key) =>
      const AndroidOptions(encryptedSharedPreferences: true);

  // iOS options for key management
  IOSOptions _getIOSOptions(String key) =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  // Generate a strong encryption key
  Future<String> _generateSecureKey() async {
    final bytes = List<int>.generate(32, (i) => Random.secure().nextInt(256));
    return sha256.convert(bytes).toString();
  }

  Future<void> saveMission(List<Map<String, dynamic>> mission) async {
    final encryptionKey = await _generateSecureKey();

    var v = json.encode(mission);
    print('=====save======');
    print(v);
    print('======save=====');

    await storage.write(
      key: 'mission',
      value: v,
      aOptions: _getAndroidOptions(encryptionKey),
      iOptions: _getIOSOptions(encryptionKey),
    );
  }

  Future<List<Map<String, dynamic>>> getFacility() async {
    final encryptionKey = await _generateSecureKey();
    try {
      final m = await storage.read(
        key: 'mission',
        aOptions: _getAndroidOptions(encryptionKey),
        iOptions: _getIOSOptions(encryptionKey),
      );

      final decoded = jsonDecode(m ?? '{}');
      if (decoded) {
        return List<Map<String, dynamic>>.from(decoded);
      } else if (decoded is Map) {
        return [Map<String, dynamic>.from(decoded)];
      } else {
        // unexpected type
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> setUser(Map<String, dynamic> mission) async {
    final encryptionKey = await _generateSecureKey();

    var v = json.encode(mission);
    print('=====save======');
    print(v);
    print('======save=====');

    await storage.write(
      key: 'user',
      value: v,
      aOptions: _getAndroidOptions(encryptionKey),
      iOptions: _getIOSOptions(encryptionKey),
    );
  }

  Future<Map<String, dynamic>> getUser() async {
    final encryptionKey = await _generateSecureKey();
    try {
      final m = await storage.read(
        key: 'user',
        aOptions: _getAndroidOptions(encryptionKey),
        iOptions: _getIOSOptions(encryptionKey),
      );

      final decoded = jsonDecode(m!);
      print(m);
      if (decoded != null) {
        print('decoded');
        print(decoded);
        print('decoded');
        return decoded;
      } else {
        // unexpected type
        print('kkk');
        print(decoded);
        print('kkkk');
        return {};
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  static Future<void> setConfigure(bool configured) async {
    sessionManager.hasAccountVal = configured;
  }

  static Future<bool?> getConfigure() async {
    return sessionManager.hasAccountVal;
  }
}
