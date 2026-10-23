import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:web_app/Utils/colors.dart';
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

  // Use semantic Material colors so controls remain legible across dark surfaces.
  ThemeData _buildDarkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: MyColor.primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: MyColor.primary,
      onPrimary: MyColor.onPrimary,
      secondary: MyColor.secondary,
      onSecondary: MyColor.onSecondary,
      tertiary: MyColor.tertiary,
      error: MyColor.error,
      onError: MyColor.onPrimary,
      surface: MyColor.darkBackground,
      onSurface: MyColor.myWhite,
      outline: MyColor.outline,
      surfaceTint: MyColor.primary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: MyColor.darkBackground,
      canvasColor: MyColor.darkBackground,
      dividerColor: MyColor.outline.withOpacity(0.55),
      appBarTheme: const AppBarTheme(
        backgroundColor: MyColor.darkSurface,
        foregroundColor: MyColor.myWhite,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: const CardThemeData(
        color: MyColor.darkSurface,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: MyColor.darkSurface,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MyColor.darkSurfaceRaised,
        labelStyle: const TextStyle(color: MyColor.myWhite70),
        hintStyle: const TextStyle(color: MyColor.myWhite60),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColor.outline.withOpacity(0.75)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: MyColor.primary, width: 2),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: MyColor.primary,
        foregroundColor: MyColor.onPrimary,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: MyColor.darkSurfaceRaised,
        contentTextStyle: TextStyle(color: MyColor.myWhite),
      ),
    );
  }

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
      theme: _buildDarkTheme(),
      home: const HomePage(),
    );
  }
}
