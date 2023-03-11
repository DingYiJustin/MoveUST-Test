import 'package:encrypt/encrypt.dart' as encrypt;

class AESEncryption {
  static final aesKey = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(aesKey));

  static encryptMsg(String text) => encrypter.encrypt(text, iv: iv);

  static decryptMsg(encrypt.Encrypted text) => encrypter.decrypt(text, iv: iv);

  getCode(String encoded) => encrypt.Encrypted.fromBase16(encoded);
}
