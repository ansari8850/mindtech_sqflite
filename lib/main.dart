import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtech_task/controller/user_controller.dart';
import 'package:mindtech_task/helper/database_helper.dart';
import 'package:mindtech_task/view/user_form_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  Get.put(UserController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: UserFormView(),
    );
  }
}
