import 'package:dsage/Inicio.dart';
import 'package:dsage/Registro.dart';
import 'package:dsage/db/helpers/user.dart';
import 'package:dsage/models/payment_arguments.dart';
import 'package:dsage/realizar_pago_del_pedido.dart';
import 'package:dsage/services/auth_service.dart';
import 'package:dsage/theme/app_theme.dart';
import 'package:dsage/views/login_view.dart';
import 'package:dsage/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Future.wait([
    Hive.openBox(UserRepository.boxName),
    Hive.openBox(AuthService.boxName),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pizza Builder',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginView()),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const RegistroScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const InicioScreen()),
    GoRoute(
      path: '/payment',
      builder: (context, state) {
        final args = state.extra as PaymentArguments?;

        if (args != null) {
          return PagoScreen(
            orderId: args.orderId,
            items: args.items,
            subtotal: args.subtotal,
            tax: args.tax,
            shippingCost: args.shippingCost,
          );
        }

        return const Scaffold(
          body: Center(child: Text('No payment arguments provided.')),
        );
      },
    ),
  ],
);
