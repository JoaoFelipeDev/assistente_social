// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Definindo nossas cores com base no seu layout
  static const Color primaryColor = Color(0xFF6A1B9A); // Um tom de roxo
  static const Color backgroundColor =
      Color(0xFFFDFBFF); // Um branco levemente arroxeado
  static const Color textColor = Color(0xFF333333);
  static const Color hintColor = Color(0xFF888888);
  static const Color accentColor =
      Color(0xFF7E57C2); // Um roxo mais claro para detalhes

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      // Cor de fundo principal do app
      scaffoldBackgroundColor: backgroundColor,

      // Tema da AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textColor, // Cor do texto e ícones na AppBar
        elevation: 0, // Sem sombra
        scrolledUnderElevation: 0,
      ),

      // Tema dos TextFields
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: hintColor),
        floatingLabelStyle: const TextStyle(color: primaryColor),
        // Para um visual mais moderno, vamos preencher o fundo
        filled: true,
        fillColor: Colors.grey.shade50,
        // Definindo um padding interno
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        // Borda padrão (quando não está focado nem com erro)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        // Borda quando o campo está focado
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        // Borda para quando há um erro
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
        ),
        // Borda para quando há um erro e o campo está focado
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
        // A propriedade 'border' é uma fallback, vamos defini-la também
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),

      // Tema da TabBar
      tabBarTheme: const TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: hintColor,
        indicatorColor: primaryColor,
      ),

      // Tema dos Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      // Resto das configurações de tema...
    );
  }
}
