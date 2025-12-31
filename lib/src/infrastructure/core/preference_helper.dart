import 'dart:convert';

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:totalx/src/domain/core/preference/preference.dart';

@LazySingleton(as: PreferenceContracts)
class PreferenceHelper implements PreferenceContracts {
  @override
  void setBool({
    required String key,
    required bool value,
    bool? isSecure,
  }) async {
    if (isSecure ?? false) {
      _setData(key, value.toString());
    } else {
      final p = await prefs;
      p.setBool(key, value);
    }
  }

  @override
  void setDouble({
    required String key,
    required double value,
    bool? isSecure,
  }) async {
    if (isSecure ?? false) {
      _setData(key, value.toString());
    } else {
      final p = await prefs;
      p.setDouble(key, value);
    }
  }

  @override
  void setInt({required String key, required int value, bool? isSecure}) async {
    if (isSecure ?? false) {
      _setData(key, value.toString());
    } else {
      final p = await prefs;
      p.setInt(key, value);
    }
  }

  @override
  void setString({
    required String key,
    required String value,
    bool? isSecure,
  }) async {
    if (isSecure ?? false) {
      _setData(key, value.toString());
    } else {
      final p = await prefs;
      p.setString(key, value);
    }
  }

  @override
  void setStringList({required String key, required List<String> value}) async {
    final p = await prefs;
    final existing = await getStringList(key: key);

    final shouldMerge = existing.isNotEmpty && !listEquals(existing, value);

    List<String> finalList;

    if (shouldMerge) {
      finalList = {...existing, ...value}.toList();
    } else {
      finalList = value;
    }
    await p.setStringList(key, finalList);
  }

  Future<void> setListMap({
    required String key,
    required List<Map<String, dynamic>> value,
  }) async {
    final p = await prefs;
    final existing = await getListMap(key: key);

    // Check if the lists should be merged
    final shouldMerge = existing.isNotEmpty && !listEquals(existing, value);

    List<Map<String, dynamic>> finalList;

    if (shouldMerge) {
      // Convert both existing and new list of maps to a set of maps (to eliminate duplicates)
      final mergedSet = {
        ...existing,
        ...value,
      }; // Merge and eliminate duplicates
      finalList = mergedSet
          .toList(); // Convert back to List<Map<String, dynamic>>
    } else {
      finalList = value; // No merge, just replace
    }

    // Encode the list of maps and store it as a string
    String encodedList = jsonEncode(finalList);
    await p.setString(key, encodedList);
  }

  @override
  Future<bool> getBool({required String key, bool? isSecure}) async {
    if (isSecure ?? false) {
      final value = await _getData(key);
      return value.toLowerCase() == 'true';
    } else {
      final p = await prefs;
      return p.getBool(key) ?? false;
    }
  }

  @override
  Future<double> getDouble({required String key, bool? isSecure}) async {
    if (isSecure ?? false) {
      final value = await _getData(key);
      return double.parse(value);
    } else {
      final p = await prefs;
      return p.getDouble(key) ?? 0.0;
    }
  }

  @override
  Future<int> getInt({required String key, bool? isSecure}) async {
    if (isSecure ?? false) {
      final value = await _getData(key);
      return int.parse(value);
    } else {
      final p = await prefs;
      return p.getInt(key) ?? 0;
    }
  }

  @override
  Future<String> getString({required String key, bool? isSecure}) async {
    if (isSecure ?? false) {
      return _getData(key);
    } else {
      final p = await prefs;
      return p.getString(key) ?? '';
    }
  }

  @override
  Future<List<String>> getStringList({required String key}) async {
    final p = await prefs;
    return p.getStringList(key) ?? [];
  }

  Future<void> removeFromStringList({
    required String key,
    required String value,
  }) async {
    final p = await prefs;
    final list = await getStringList(key: key);
    list.remove(value);
    await p.setStringList(key, list);
  }

  Future<List<Map<String, dynamic>>> getListMap({required String key}) async {
    final p = await prefs;
    String? encodedList = p.getString(key);

    if (encodedList != null) {
      List<dynamic> decodedList = jsonDecode(encodedList);
      return decodedList
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();
    } else {
      return [];
    }
  }


  Future<void> removeFromListMap({
    required String key,
    required String value,
  }) async {
    final p = await prefs;
    final list = await getListMap(key: key);
    final map = jsonDecode(value);
    list.remove(map);
    await p.setString(key, jsonEncode(list));
  }

  Future<bool> containsKey({required String key}) async {
    final p = await prefs;
    return p.containsKey(key);
  }

  Future<bool> clearAll({bool? isSecure}) async {
    if (isSecure ?? false) {
      const storage = FlutterSecureStorage();
      storage.deleteAll();
    } else {
      final p = await prefs;
      p.clear();
    }
    return true;
  }

  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  Future<void> storeCredentials(String username, String password) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: username, value: password);
  }

  Future<String?> getPassword(String username) async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: username);
  }

  Future<String> _getData(String key) async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: key) ?? '';
  }

  Future<void> _setData(String key, String value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  Future<bool> remove({required String key}) async {
    final p = await prefs;
    return p.remove(key);
  }
}
