import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../data/app_database.dart';
import 'shell.dart';
import 'theme.dart';

class App extends StatelessWidget {
  final AppDatabase db;
  const App({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
        builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'إدارة العتاد',
          theme: buildEnterpriseTheme(),

          // Single-language Arabic (RTL)
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          home: AppShell(db: db),
        );
      }
    );
  }
}
