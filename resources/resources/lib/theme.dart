import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData get appTheme => ThemeData(
      useMaterial3: true,
      appBarTheme: appBarTheme,
      primarySwatch: Colors.blue,
      colorScheme: const ColorScheme.dark(
        primary: Colors.blueAccent,
        surface: Color(0xFF0c0e12),
        onPrimary: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF0c0e12),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.red,
        selectionColor: Color(0xFFFFD700),
        selectionHandleColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700), // gold
          foregroundColor: Colors.black, // text/icon color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          visualDensity: VisualDensity.comfortable,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        fillColor: const Color(0xFF1E1E1E),
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Color(0xFFFFD700),
        elevation: 0,
      ),
    );

AppBarTheme get appBarTheme => const AppBarTheme(
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      color: Color(0xFF0c0e12),
      actionsIconTheme: IconThemeData(
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
