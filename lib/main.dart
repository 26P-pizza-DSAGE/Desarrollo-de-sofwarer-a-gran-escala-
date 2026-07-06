import 'package:dsage/Inicio.dart';
import 'package:dsage/Registro.dart';
import 'package:dsage/db/helpers/user.dart';
import 'package:dsage/realizar_pago_del_pedido.dart';
import 'package:dsage/services/auth_service.dart';
import 'package:dsage/theme/app_theme.dart';
import 'package:dsage/views/login_view.dart';
import 'package:dsage/views/splash_view.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Pizza Builder',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: '/payment',
      routes: {
        '/': (context) => const SplashScreen(),
        //'/login': (context) => const LoginView(),
        '/sign-up': (context) => const RegistroScreen(),
        '/home': (context) => const InicioScreen(),
        '/login': (context) {
          final items = [
            OrderItem(name: 'Pizza Margarita', price: 12.99, quantity: 2),
            OrderItem(name: 'Pizza Pepperoni', price: 14.99, quantity: 1),
            OrderItem(name: 'Coca Cola 2L', price: 3.50, quantity: 2),
          ];

          final subtotal = items.fold<double>(
            0,
            (sum, item) => sum + (item.price * item.quantity),
          );

          return PagoScreen(
            orderId: 'ORD-2024-001',
            items: items,
            subtotal: subtotal,
            tax: subtotal * 0.08,
            shippingCost: 4.99,
          );
        },
      },
    );
  }
}
