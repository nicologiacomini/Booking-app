import 'package:book_app/firebase_options.dart';
import 'package:book_app/pages/home_page.dart';
import 'package:book_app/pages/login.dart';
import 'package:book_app/pages/main_page.dart';
import 'package:book_app/pages/new_event_page.dart';
import 'package:book_app/pages/new_promoter_page.dart';
import 'package:book_app/pages/result_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor myCustomColor = const MaterialColor(
      0x00000000,
      <int, Color>{
        50: Color(0xFFFAFAFA),
        100: Color(0xFFF5F5F5),
        200: Color(0xFFEEEEEE),
        300: Color(0xFFE0E0E0),
        350: Color(
            0xFF424242), // only for raised button while pressed in light theme
        400: Color(0xFFBDBDBD),
        500: Color(0xFF9E9E9E),
        600: Color(0xFF757575),
        700: Color(0xFF616161),
        800: Color(0xFF424242),
        850: Color(0xFF303030), // only for background color in dark theme
        900: Color(0xFF212121),
      },
    );

    return MaterialApp(
      title: "Funway Booking",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: myCustomColor,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black, primary: Colors.black),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.black),
        scaffoldBackgroundColor: Colors.deepOrange.shade200,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade800),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pink.shade400),
          ),
        ),
      ),
      // home: const MainPage(),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/login': (context) => const Login(),
        '/home': (context) => const HomePage(),
        '/result': (context) => const ResultPage(data: []),
        '/new_promoter': (context) => const NewPromoterPage(),
        '/new_event': (context) => const NewEventPage()
      },
    );
  }
}
