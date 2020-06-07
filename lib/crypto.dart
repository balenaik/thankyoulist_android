import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class Crypto {
  String decryptAESCrypto(String encrypted, String passphrase) {
    final key = Key.fromUtf8(passphrase);
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: "PKCS7"));
    final decrypted = encrypter.decrypt64(encrypted);
    return decrypted;
  }
}