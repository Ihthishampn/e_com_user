import 'package:e_com_user/features/Auth/presentation/view/login_screen.dart';
import 'package:e_com_user/features/Auth/presentation/view/otp_screen.dart';
import 'package:e_com_user/features/Home/presentation/view/home_screen.dart';
import 'package:e_com_user/features/Root/presentation/view/root_screen.dart';
import 'package:e_com_user/general/services/go_route/route_names.dart';
import 'package:go_router/go_router.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: RouteNames.login,
  routes: [
    GoRoute(path: RouteNames.login, builder: (context, state) => LoginScreen()),

    GoRoute(path: RouteNames.home, builder: (context, state) => HomeScreen()),
    GoRoute(path: RouteNames.otp, builder: (context, state) => OtpScreen(phoneN: "",)),
    GoRoute(path: RouteNames.root, builder: (context, state) => RootScreen()),
  ],
);
