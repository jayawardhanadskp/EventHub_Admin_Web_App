import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'login/login.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyA71UrBPlvvzsW2VIT9MAfhxUPNY_dTQjk',
          appId: '1:951945595901:web:3427b4cb0198774a9da794',
          messagingSenderId: '951945595901',
          projectId: 'eventhub-2beb6'
      ),
    );
  }  else {
    await Firebase.initializeApp();
  }




  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventHub Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.white),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: Login(),
      builder: EasyLoading.init(),

    );
  }
}
