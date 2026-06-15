import 'package:e_com_user/features/Auth/presentation/view/login_screen.dart';
import 'package:e_com_user/features/Auth/presentation/view/otp_screen.dart';
import 'package:e_com_user/features/Home/presentation/view/home_screen.dart';
import 'package:e_com_user/features/Cart/presentation/view/cart_screen.dart';
import 'package:e_com_user/features/Root/presentation/view/root_screen.dart';
import 'package:e_com_user/features/favourite/presentation/view/favourite_screen.dart';
import 'package:e_com_user/general/services/go_route/otp_args.dart';
import 'package:e_com_user/general/services/go_route/route_names.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter({required bool isLoggedIn}) {
  final initial = isLoggedIn ? RouteNames.root : RouteNames.login;

  return GoRouter(
    initialLocation: initial,
    routes: [
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: RouteNames.otp,
        builder: (context, state) {
          final args = state.extra as OtpArgs;

          return OtpScreen(phoneN: args.phone, name: args.name);
        },
      ),

      GoRoute(
        path: RouteNames.root,
        builder: (context, state) => const RootScreen(),
      ),
      GoRoute(
        path: RouteNames.fav,
        builder: (context, state) => const FavouriteScreen(),
      ),
      GoRoute(
        path: RouteNames.cart,
        builder: (context, state) => const CartScreen(),
      ),
    ],
  );
}