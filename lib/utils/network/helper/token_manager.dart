import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  TokenManager._();
  static final TokenManager _instance = TokenManager._();
  factory TokenManager() => _instance;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  // Save access token
  Future<void> setAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  // Retrieve access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Save refresh token
  Future<void> setRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  // Retrieve refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Delete tokens
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> checkIfAccessTokenPresent() async {
    final prefs = await SharedPreferences.getInstance();
    print('access toke: ${prefs.getString(_accessTokenKey)}');
    print('refresh toke: ${prefs.getString(_refreshTokenKey)}');

    if (prefs.getString(_accessTokenKey) != null) {
      return true;
    }
    return false;
  }
}
