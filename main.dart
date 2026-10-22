import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app/Utils/firebase_options.dart';
import 'package:web_app/home_page.dart';
import 'package:web_app/provider_function/logic_function.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoodItemProperty()),
        ChangeNotifierProvider(create: (_) => TextFieldChanger()),
        ChangeNotifierProvider(create: (_) => OrderFoodItems()),
        ChangeNotifierProvider(create: (_) => UserOrdersFind()),
        ChangeNotifierProvider(create: (_) => GetImgLocal()),
      ],
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      }),
      title: 'スリランカ味',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black12),
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
