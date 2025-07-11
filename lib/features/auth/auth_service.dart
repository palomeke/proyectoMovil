import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveUserSession(String uid) async {
    await _storage.write(key: 'uid', value: uid);
  }

  Future<String?> getUserSession() async {
    return await _storage.read(key: 'uid');
  }

  Future<void> clearSession() async {
    await _storage.delete(key: 'uid');
  }
}
