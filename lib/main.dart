import 'package:dsage/Inicio.dart';
import 'package:dsage/Registro.dart';
import 'package:dsage/db/helpers/user.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginView(),
        '/sign-up': (context) => const RegistroScreen(),
        '/home': (context) => const InicioScreen(),
      },
    );
  }
}
