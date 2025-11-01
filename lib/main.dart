import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_list_test/config/constants/consts.dart';
import 'package:invoice_list_test/config/router/router.dart';
import 'package:invoice_list_test/config/theme/app_theme.dart';
import 'package:invoice_list_test/data/shared_preferences/shared_prefs.dart';
import 'package:invoice_list_test/presentation/providers/theme/is_dark_theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.instance.initPrefs();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // precacheImage(const AssetImage(ApkConsts.loadingGifPlaceholder), context);
    return Consumer(
      builder: (context, ref, child) {
        final brightness = ref.watch(isDarkThemeProvider);
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: ApkConsts.apkName,
          theme: AppTheme().themeLight(),
          darkTheme: AppTheme().themeDark(),
          themeMode: (brightness)
              ? ThemeMode.dark
              : (!brightness)
              ? ThemeMode.light
              : ThemeMode.system,
          routerConfig: ref.read(routerProvider),
        );
      },
    );
  }
}
