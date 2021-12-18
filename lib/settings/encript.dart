import 'package:cotizapack/common/Collections_api.dart';
import 'package:encrypt/encrypt.dart';

class Encript {
  final key = Key.fromUtf8(Collections.KEYENCRIPT);
  String encription(String data) {
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(16);

    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  String desencription(String encrypted) {
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(16);
    final data = IV.fromBase64(encrypted);
    return encrypter.decrypt(data, iv: iv);
  }
}
