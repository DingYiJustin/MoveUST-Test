import 'dart:async';

import 'package:flutter/material.dart';

import 'secureStorageManager.dart';

class RegularStorage{
  //current values that may be passed to the backend
  late Map<String,String> currentValues;
  late SecureStorageManager storageManager;
  RegularStorage(){
    SecureStorageManager storageManager = SecureStorageManager();
    _initCurrentValues();
  }

  Future<void> _initCurrentValues() async{
    currentValues =  await storageManager.readAll();
  }

}
