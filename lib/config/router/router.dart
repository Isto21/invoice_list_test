import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_list_test/data/shared_preferences/constants_shared_prefs.dart';
import 'package:invoice_list_test/data/shared_preferences/shared_prefs.dart';
import 'package:invoice_list_test/presentation/pages/auth/login_page.dart';
import 'package:invoice_list_test/presentation/pages/home/home_page.dart';

import 'router_path.dart';
import 'router_transition.dart';

final routerProvider = StateProvider<GoRouter>((ref) {
  final refresh = Prefs.instance.getValue(ConstantsSharedPrefs.accessToken);
  return GoRouter(
    initialLocation: (refresh.toString().isEmpty || refresh == null)
        ? RouterPath.LoginPage
        : RouterPath.HomePage,
    routes: [
      GoRoute(
        path: RouterPath.HomePage,
        pageBuilder: (context, state) => RouterTransition.fadeTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
        ),
      ),

      GoRoute(
        path: RouterPath.LoginPage,
        pageBuilder: (context, state) => RouterTransition.fadeTransitionPage(
          key: state.pageKey,
          child: LoginPage(),
        ),
      ),
    ],
  );
});
