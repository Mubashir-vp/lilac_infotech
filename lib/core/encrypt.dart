import 'package:encrypt/encrypt.dart';

class MyEncrypt {
  static final myKey = Key.fromUtf8('my 32 length key................');
  static final myIv = IV.fromUtf8('qwertyuiopasdfgh');
  static final myEncrypter = Encrypter(
    AES(
      myKey,
      padding: null,
    ),
  );
}
