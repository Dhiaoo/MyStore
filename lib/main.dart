import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'DatabaseServices/database.dart';
import 'HomePage/Views/HomePage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "My Store ",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  HomePage(),
    );
  }
}
