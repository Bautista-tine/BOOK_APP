import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() => runApp(const BookApp());

class BookApp extends StatefulWidget {
  const BookApp({super.key});

  @override
  State<BookApp> createState() => _BookAppState();
}

class _BookAppState extends State<BookApp> {
  bool isDark = true;

  void toggleTheme() => setState(() => isDark = !isDark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book App',
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: HomePage(toggleTheme: toggleTheme, isDark: isDark),
      debugShowCheckedModeBanner: false,
    );
  }
}
