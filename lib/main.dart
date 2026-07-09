import 'package:dsage/features/custom/screens/custom_order.dart';
import 'package:dsage/features/home/screens/home_screen.dart';
import 'package:dsage/features/auth/screens/registro_screen.dart';
import 'package:dsage/shared/helpers/user.dart';
import 'package:dsage/shared/model/payment_arguments.dart';
import 'package:dsage/shared/model/pizza.dart';
import 'package:dsage/realizar_pago_del_pedido.dart';
import 'package:dsage/services/auth_service.dart';
import 'package:dsage/theme/app_theme.dart';
import 'package:dsage/views/login_view.dart';
import 'package:dsage/views/splash_view.dart';
import 'package:dsage/views/tracking_view.dart';
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
      path: '/checkout',
      builder: (context, state) {
        final map = state.extra as Map<String, dynamic>? ?? {};

        return PagoScreen(
          orderId: map['orderId'] as String? ?? '0000',
          items: map['items'] as List<Pizza>? ?? <Pizza>[],
          subtotal: map['subtotal'] as double? ?? 0.0,
          tax: map['tax'] as double? ?? 0.0,
          shippingCost: map['shippingCost'] as double? ?? 0.0,
        );
      },
    ),
    GoRoute(
      path: '/customize',
      builder: (context, state) => const CustomOrderScreen(),
    ),
    GoRoute(
      path: '/tracking',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Seguimiento de Entrega'))),
    ),
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

        return const Scaffold(body: Center(child: Text('No hay productos.')));
      },
    ),
    GoRoute(
      path: '/tracking',
      builder: (context, state) {
        final orderId = state.extra as String?;
        return TrackingView(orderId: orderId);
      },
    ),
  ],
);
