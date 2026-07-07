import 'package:dsage/shared/helpers/user.dart';
import 'package:dsage/shared/model/user.dart';
import 'package:dsage/features/home/widgets/home_body.dart';
import 'package:dsage/features/home/widgets/pizza_detail_sheet.dart';
import 'package:dsage/shared/model/pizza.dart';
import 'package:dsage/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final int? userId = AuthService.getUserId();

    if (userId == null) {
      if (mounted) context.go('/login');
      return;
    }

    final User? user = UserRepository.instance.getUserById(userId);
    if (!mounted) return;

    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Estás seguro de que deseas salir?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Salir'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    await AuthService.clearSession();
    if (!mounted) return;
    context.go('/login');
  }

  void _showPizzaDetail(BuildContext context, Pizza pizza) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PizzaDetailSheet(pizza: pizza),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Icon(Icons.local_pizza, color: cs.primary, size: 26),
            const SizedBox(width: 10),
            Flexible(
              child: _isLoading
                  ? Text(
                      'Pizza Builder',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    )
                  : Row(
                      children: [
                        Text(
                          'Hola, ${_currentUser?.username ?? 'Usuario'}',
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.waving_hand, color: cs.primary, size: 26),
                      ],
                    ),
            ),
          ],
        ),
        actions: [
          if (!_isLoading)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: const Icon(Icons.logout_outlined),
                tooltip: 'Cerrar sesión',
                color: cs.onSurfaceVariant,
                onPressed: _logout,
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : HomeBody(
              user: _currentUser!,
              onPizzaTap: (pizza) => _showPizzaDetail(context, pizza),
            ),
    );
  }
}
