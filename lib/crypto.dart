import 'package:encrypt/encrypt.dart';

const PKCS7 = 'PKCS7';

class Crypto {
  String encryptAESCrypto(String plainText, String passphrase) {
    final key = Key.fromUtf8(passphrase);
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: PKCS7));
    final encrypted = encrypter.encrypt(plainText);
    return encrypted.base64;
  }

  String decryptAESCrypto(String encryptedText, String passphrase) {
    final key = Key.fromUtf8(passphrase);
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: PKCS7));
    final decryptedText = encrypter.decrypt64(encryptedText);
    return decryptedText;
  }
}