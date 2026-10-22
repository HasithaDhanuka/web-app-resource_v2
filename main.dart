import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:web_app/Utils/firebase_options.dart';
import 'package:web_app/home_page.dart';
import 'package:web_app/invoice_pdf/pdf_view_screen.dart';
import 'package:web_app/provider_function/logic_function.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoodItemProperty()),
        ChangeNotifierProvider(create: (_) => TextFieldChanger()),
        ChangeNotifierProvider(create: (_) => OrderFoodItems()),
        ChangeNotifierProvider(create: (_) => UserOrdersFind()),
        ChangeNotifierProvider(create: (_) => GetImgLocal()),
        ChangeNotifierProvider(create: (_) => DatabaseClassifier()),
        //  ChangeNotifierProvider(create: (_) => DeleteOrdersIncome()),
      ],
      builder: (context, child) => const MyApp(),
    ),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/home",
      routes: {
        "/home": (context) => HomePage(),
        "/pdf": (context) => InvoiceView(),
      },
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      }),
      title: 'セイロン味',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black12),
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
