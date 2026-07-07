import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/theme/theme_provider.dart';
import 'features/auth/presentation/pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode:
      theme.isDark ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        brightness: Brightness.light,

        primaryColor: const Color(0xff2563EB),

        scaffoldBackgroundColor: const Color(0xffF5F7FB),

        canvasColor: const Color(0xffF5F7FB),

        cardColor: Colors.white,

        dividerColor: Colors.grey.shade300,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffF5F7FB),
          foregroundColor: Colors.black,
          elevation: 0,
        ),

        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 0,
        ),

        dialogTheme: const DialogThemeData(
          backgroundColor: Colors.white,
        ),

        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xff2563EB),
          brightness: Brightness.light,
          surface: Colors.white,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,

        primaryColor: const Color(0xff2563EB),

        scaffoldBackgroundColor: const Color(0xff121212),

        canvasColor: const Color(0xff121212),

        cardColor: const Color(0xff1E1E1E),

        dividerColor: Colors.white24,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff121212),
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        cardTheme: const CardThemeData(
          color: Color(0xff1E1E1E),
          elevation: 0,
        ),

        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xff1E1E1E),
        ),

        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xff2563EB),
          brightness: Brightness.dark,
          surface: Color(0xff1E1E1E),
        ),
      ),

      home: const SplashPage(),
    );
  }
}