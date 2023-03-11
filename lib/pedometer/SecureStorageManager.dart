// import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager{
  late final FlutterSecureStorage _storage=const FlutterSecureStorage();


  //IOS settings, not usable with our app since the user should not input,
  //we should only implement this setting after having backend

  IOSOptions _getIOSOptions() => const IOSOptions(
    accountName: AppleOptions.defaultAccountName,
  );
  // final _accountNameController =
  //     TextEditingController(text: 'flutter_secure_storage_service');
  // IOSOptions _getIOSOptions() => IOSOptions(
  //         accountName: _getAccountName(),
  //       );
    // String? _getAccountName() =>
  //     _accountNameController.text.isEmpty ? null : _accountNameController.text;

  //choose the encrypted shared perference mode in android api
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  Future<Map<String,String>> readAll() async {
    Map<String, String> all = await _storage.readAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    return all;
  }

  Future<String?> read(String key) async {
    String? value = await _storage.read(
      key: key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    return value;
  }

  Future<bool> deleteAll() async {
    try{
      await _storage.deleteAll(
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
      return true;
    }catch(e){
      return false;
    }
  }

  Future<bool> delete(String key) async{
    try{
      await _storage.delete(
        key: key,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
      return true;
    }catch(e){
      return false;
    }
    
  }

  Future<bool> write(String key, String value) async {
    try{
      await _storage.write(
        key: key,
        value: value,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
      return true;
    }catch(e){
      return false;
    }
    
  }

}