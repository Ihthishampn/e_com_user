import 'package:e_com_user/features/Auth/presentation/provider/auth_provider.dart';
import 'package:e_com_user/firebase_options.dart';
import 'package:e_com_user/general/core/injection/injection_config.dart';
import 'package:e_com_user/general/services/go_route/route_config.dart';
import 'package:e_com_user/general/services/local_storage/app_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await confirugationDependency();
  await Firebase.initializeApp(
    name: "ihthisham",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = getIt<AppPreferences>();
  final router = createRouter(isLoggedIn: prefs.isLoggedin());

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => getIt<AuthProvider>())],
      child: EcomUserApp(router: router),
    ),
  );
}

class EcomUserApp extends StatelessWidget {
  final GoRouter router;

  const EcomUserApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: AppColors.bgWhite),
        routerConfig: router,
      ),
    );
  }
}
