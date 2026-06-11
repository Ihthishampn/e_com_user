import 'package:e_com_user/features/Auth/presentation/provider/auth_provider.dart';
import 'package:e_com_user/features/Category/presentation/provider/category_provider.dart';
import 'package:e_com_user/features/Home/presentation/provider/home_provider.dart';
import 'package:e_com_user/features/Home/presentation/provider/product_provider.dart';
import 'package:e_com_user/features/favourite/presentation/provider/fav_provider.dart';
import 'package:e_com_user/firebase_options.dart';
import 'package:e_com_user/general/core/injection/injection_config.dart';
import 'package:e_com_user/general/services/go_route/route_config.dart';
import 'package:e_com_user/general/services/local_storage/app_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sendotp_flutter_sdk/sendotp_flutter_sdk.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await confirugationDependency();
  await Firebase.initializeApp(
    name: "ihthisham",
    options: DefaultFirebaseOptions.currentPlatform,
    );
    OTPWidget.initializeWidget(
  dotenv.env['MSG91_WIDGET_ID']!,
  dotenv.env['MSG91_AUTH_TOKEN']!,
);
  final prefs = getIt<AppPreferences>();
  final router = createRouter(isLoggedIn: prefs.isLoggedin());

  if (!getIt.isRegistered<CategoryProvider>()) {
    final catProv = CategoryProvider();
    getIt.registerSingleton<CategoryProvider>(catProv);
  }

  if (!getIt.isRegistered<ProductProvider>()) {
    final prodProv = ProductProvider();
    getIt.registerSingleton<ProductProvider>(prodProv);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<CategoryProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ProductProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<FavProvider>()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
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
