import 'package:dsage/Inicio.dart';
import 'package:dsage/Realizar_pago_del_pedido.dart';
import 'package:dsage/Registro.dart';
import 'package:dsage/db/helpers/user.dart';
import 'package:dsage/models/payment_arguments.dart';
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

  //   final GoRouter router = GoRouter(
  //   routes: [
  //     GoRoute(
  //       path: '/',
  //       builder: (context, state) => const SplashScreen(),
  //     ),
  //     GoRoute(
  //       path: '/login',
  //       builder: (context, state) => const LoginView(),
  //     ),
  //     GoRoute(
  //       path: '/payment',
  //       builder: (context, state) {
  //         final args = state.extra as PaymentArguments;

  //         return PagoScreen(
  //           orderId: args.orderId,
  //           items: args.items as List<OrderItem>,
  //           subtotal: args.subtotal,
  //           tax: args.tax,
  //           shippingCost: args.shippingCost,
  //         );
  //       },
  //     ),
  //   ],
  // );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Builder',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginView(),
        '/sign-up': (context) => const RegistroScreen(),
        '/home': (context) => const InicioScreen(),
        // '/payment': (context) =>  const PagoScreen(orderId: orderId, items: items, subtotal: subtotal, tax: tax, shippingCost: shippingCost,)
      },
    );
  }
}
