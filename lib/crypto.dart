import 'package:encrypt/encrypt.dart';

const PKCS7 = 'PKCS7';

class Crypto {
  String encryptAESCrypto(String plainText, String passphrase) {
    final key = Key.fromUtf8(passphrase);
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: PKCS7));
    final iv = IV.fromUtf8(passphrase);
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String decryptAESCrypto(String encryptedText, String passphrase) {
    final key = Key.fromUtf8(passphrase);
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: PKCS7));
    final iv = IV.fromUtf8(passphrase);
    final decryptedText = encrypter.decrypt64(encryptedText, iv: iv);
    return decryptedText;
  }
}