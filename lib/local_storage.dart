import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  final storage = const FlutterSecureStorage();

  Future<void> saveJWT(String jwt) async {
    return await storage.write(key: "jwt", value: jwt);
  }

  Future<String?> getJWT() async {
    return await storage.read(key: "jwt");
  }
}
