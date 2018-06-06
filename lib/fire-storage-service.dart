import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

  Future <FirebaseStorage> fireStorage() async {
   
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'test',
    options: new FirebaseOptions(
      googleAppID: Platform.isIOS
          ? '1:521338178746:ios:a0799180a81f4612'
          : '1:521338178746:android:78a5b64eedbc7a50',
      gcmSenderID: '521338178746', 
      apiKey: 'AIzaSyDae_ruLiwR6acTsRaTsQrzV0CBnLBJGvQ',
      projectID: 'voom-1526411592832',
    ),
  );
  final FirebaseStorage storage = new FirebaseStorage(
      app: app, storageBucket: 'gs://voom-1526411592832.appspot.com');
 return storage;
}