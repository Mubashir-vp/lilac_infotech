import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:lilac_info_tech/core/encrypt.dart';

class VideoServices {
  getNormalFile(Directory directory, fileName) async {
    try {
      Uint8List? encData = await _readData('$fileName.aes');
      var plainData = await decryptData(encData);
      String p = await writeData(plainData, fileName);
      dev.log('File decrypted successfully : $p');
      return p;
    } catch (e) {
      dev.log('Error Occured in _getNormalFile$e');
    }
  }

  writeData(dataTowrite, fileNameWithPath) async {
    dev.log('writing data...');
    File f = File(fileNameWithPath);
    await f.writeAsBytes(dataTowrite);
    return f.absolute.toString();
  }

  Future<Uint8List?> _readData(fileNameWithPath) async {
    try {
      dev.log('Reading data... $fileNameWithPath');
      File f = File(fileNameWithPath);
      return await f.readAsBytes();
    } catch (e) {
      dev.log('Error Occured in _readData $e');
      return null;
    }
  }

  decryptData(encData) {
    try {
      dev.log('File decryption in progress');
      enc.Encrypted en = enc.Encrypted(encData);
      return MyEncrypt.myEncrypter.decryptBytes(en, iv: MyEncrypt.myIv);
    } catch (e) {
      dev.log('Error occured in _decryptData $e');
    }
  }

  newEncryptFile(
    filepath,
  ) async {
    try {
      final encrypted =
          MyEncrypt.myEncrypter.encryptBytes(filepath, iv: MyEncrypt.myIv);
      return encrypted.bytes;
    } catch (e) {
      dev.log('Error in encryption$e');
    }
  }

  Future<Directory> get getExternalVisibleDir async {
    if (await Directory('/storage/emulated/0/MyEncFolder').exists()) {
      final dir = Directory('/storage/emulated/0/MyEncFolder');
      return dir;
    } else {
      await Directory('/storage/emulated/0/MyEncFolder')
          .create(recursive: true);
      final dir = Directory('/storage/emulated/0/MyEncFolder');
      return dir;
    }
  }
}
