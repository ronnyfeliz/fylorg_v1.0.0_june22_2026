import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'data/models/move_log_entry.dart';
import 'data/models/organize_rule.dart';
import 'data/providers/locale_provider.dart';
import 'data/providers/theme_provider.dart';
import 'data/repositories/rules_repository.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(OrganizeRuleAdapter());
  Hive.registerAdapter(MoveLogEntryAdapter());

  await Hive.openBox<OrganizeRule>('rules_box');
  await Hive.openBox('settings_box');
  await Hive.openBox<MoveLogEntry>('history_box');

  final repo = RulesRepository();
  await repo.init();

  runApp(const ProviderScope(child: FylorgApp()));
}

class FylorgApp extends ConsumerWidget {
  const FylorgApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Fylorg',
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: const [
        Locale('es'), Locale('en'), Locale('it'), Locale('ru'),
        Locale('ja'), Locale('zh'), Locale('pt'), Locale('fr'),
        Locale('ko'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: themeMode,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    
    final primaryColor = isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5);
    final secondaryColor = isDark ? const Color(0xFF34D399) : const Color(0xFF059669);
    final backgroundColor = isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC);
    final surfaceColor = isDark ? const Color(0xFF131B2E) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final outlineColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    
    final scheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      brightness: brightness,
    ).copyWith(
      outline: outlineColor,
      outlineVariant: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      dialogBackgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
      fontFamily: 'Segoe UI',
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: isDark ? Colors.white : const Color(0xFF1E293B)),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF1E293B),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Segoe UI',
        ),
      ),
      
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: outlineColor, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? const Color(0xFF131B2E) : Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: outlineColor, width: isDark ? 1 : 0),
        ),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF1E293B),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Segoe UI',
        ),
        contentTextStyle: TextStyle(
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
          fontSize: 15,
          fontFamily: 'Segoe UI',
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            fontFamily: 'Segoe UI',
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            fontFamily: 'Segoe UI',
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: 'Segoe UI',
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        labelStyle: TextStyle(
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          fontSize: 14,
        ),
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      
      dividerTheme: DividerThemeData(
        color: outlineColor,
        space: 24,
        thickness: 1,
      ),
      
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
        textColor: isDark ? Colors.white : const Color(0xFF1E293B),
      ),
    );
  }
}
