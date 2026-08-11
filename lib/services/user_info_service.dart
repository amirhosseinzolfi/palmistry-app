import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_info.dart';

class UserInfoService {
  static const String _userPrefsKey = 'user_info_data';
  static const String _serverUrlPrefsKey = 'backend_server_url';
  
  // Default server URLs: 127.0.0.1 for desktop/web, 10.0.2.2 for Android emulator
  static const String _defaultDesktopUrl = 'http://127.0.0.1:8000';

  // Get configured FastAPI Server base URL
  Future<String> getServerUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_serverUrlPrefsKey) ?? _defaultDesktopUrl;
  }

  // Set custom FastAPI Server base URL
  Future<void> setServerUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_serverUrlPrefsKey, url);
  }

  // Load user info saved on phone
  Future<UserInfoModel?> loadLocalUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString(_userPrefsKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final Map<String, dynamic> data = jsonDecode(jsonStr);
        return UserInfoModel.fromJson(data);
      }
    } catch (e) {
      debugPrint("Error loading user info from local storage: $e");
    }
    return null;
  }

  // Save user info locally to SharedPreferences on phone
  Future<bool> saveLocalUserInfo(UserInfoModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonStr = jsonEncode(user.toJson());
      return await prefs.setString(_userPrefsKey, jsonStr);
    } catch (e) {
      debugPrint("Error saving user info to local storage: $e");
      return false;
    }
  }

  // Send user info to FastAPI server and update local sync status
  Future<Map<String, dynamic>> saveAndSyncUserInfo(UserInfoModel user) async {
    // 1. Save locally first so phone data is immediately persisted
    await saveLocalUserInfo(user.copyWith(isSynced: false));

    // 2. Try sending request to FastAPI backend server
    try {
      final String baseUrl = await getServerUrl();
      final Uri endpoint = Uri.parse('$baseUrl/api/user_info');
      
      final response = await http.post(
        endpoint,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toServerJson()),
      ).timeout(const Duration(seconds: 7));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String syncedTime = DateTime.now().toIso8601String();
        
        final UserInfoModel syncedUser = user.copyWith(
          isSynced: true,
          lastSyncedAt: syncedTime,
        );
        
        // Update local storage with sync success status
        await saveLocalUserInfo(syncedUser);

        return {
          'success': true,
          'message': 'اطلاعات با موفقیت در گوشی ذخیره و به سرور ارسال شد',
          'data': syncedUser,
          'server_response': responseData,
        };
      } else {
        return {
          'success': false,
          'message': 'خطا در پاسخ سرور (کد ${response.statusCode}) - اطلاعات در گوشی ذخیره شد',
          'data': user,
        };
      }
    } catch (e) {
      debugPrint("FastAPI server connection error: $e");
      return {
        'success': false,
        'message': 'سرور در دسترس نیست - اطلاعات با موفقیت در گوشی ذخیره شد',
        'data': user,
        'error': e.toString(),
      };
    }
  }

  // Attempt to sync locally saved offline data with FastAPI backend
  Future<bool> syncPendingLocalData() async {
    final UserInfoModel? localUser = await loadLocalUserInfo();
    if (localUser != null && !localUser.isSynced) {
      final result = await saveAndSyncUserInfo(localUser);
      return result['success'] == true;
    }
    return false;
  }
}
