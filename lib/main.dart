import 'package:e_com_user/features/Auth/presentation/provider/auth_provider.dart';
import 'package:e_com_user/firebase_options.dart';
import 'package:e_com_user/general/core/injection/injection_config.dart';
import 'package:e_com_user/general/services/go_route/route_config.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await confirugationDependency();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
      ],
      child: const EcomUserApp(),
    ),
  );
}

class EcomUserApp extends StatelessWidget {
  const EcomUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: AppColors.bgWhite),
        routerConfig: goRouter,
      ),
    );
  }
}