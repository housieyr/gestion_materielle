import 'package:flutter/material.dart';

/// Enterprise-friendly theme: calm colors, dense inputs, consistent shapes.
ThemeData buildEnterpriseTheme() {
  final base = ThemeData(
    useMaterial3: true,colorSchemeSeed: Colors.green,dividerColor: Colors.white

  );

  return base.copyWith(
    visualDensity: VisualDensity.standard,
    /// INPUT FIELD STYLE (affects dropdown fields too)
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.green.shade600, width: 1.5),
      ),
    ),

    /// MATERIAL 3 DROPDOWN (DropdownMenu)
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: const TextStyle(fontSize: 14),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        elevation: const WidgetStatePropertyAll(4),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),

    /// CLASSIC DropdownButton


    /// POPUP MENU STYLE
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        elevation: const WidgetStatePropertyAll(4),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
    ),

    /// CARD STYLE
    cardTheme: const CardThemeData(
      shadowColor: Colors.indigo,
      color: Colors.white,
      margin: EdgeInsets.zero,
    ),
  );
}

