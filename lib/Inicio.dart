import 'dart:ffi';

import 'package:dsage/db/helpers/user.dart';
import 'package:dsage/db/model/user.dart';
import 'package:dsage/services/auth_service.dart';
import 'package:flutter/material.dart';

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
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
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
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Widget _buildPizzaCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    String pizzaName,
    String pizzaDescription,
    double pizzaPrice,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/pizza_details',
          arguments: {
            'name': pizzaName,
            'description': pizzaDescription,
            'price': pizzaPrice,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(60),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pizzaName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              pizzaDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Precio: \$${pizzaPrice.toStringAsFixed(2)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),

            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/order_pizza',
                  arguments: pizzaName,
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Ordenar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Icon(Icons.local_pizza, color: colorScheme.primary, size: 26),
            const SizedBox(width: 10),
            Flexible(
              child: _isLoading
                  ? Text(
                      'Pizza Builder',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    )
                  : Text(
                      'Hola, ${_currentUser?.username ?? 'Usuario'} \u{1F44B}',
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
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
                color: colorScheme.onSurfaceVariant,
                onPressed: _logout,
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildHomeContent(theme, colorScheme),
    );
  }

  Widget _buildHomeContent(ThemeData theme, ColorScheme colorScheme) {
    final User user = _currentUser!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colorScheme.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(60),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: colorScheme.primary.withAlpha(40),
                  child: Text(
                    user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : '?',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: user.role == Role.admin
                              ? colorScheme.secondary.withAlpha(40)
                              : colorScheme.primary.withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user.role == Role.admin ? 'Admin' : 'Usuario',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: user.role == Role.admin
                                ? colorScheme.secondary
                                : colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Text(
            'Arma tu pizza',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          // banner promocional de pizzas personalizadas
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colorScheme.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(60),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '¡Crea tu pizza personalizada!',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Elige tus ingredientes favoritos y crea la pizza perfecta para ti.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/custom_pizza');
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Crear Pizza'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // pizza recomendada del día
          Text(
            'Pizza recomendada del día',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withAlpha(30),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colorScheme.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(60),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Pizza del día: Margarita',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Disfruta de nuestra pizza Margarita, con salsa de tomate, queso mozzarella y albahaca fresca. ¡Una opción clásica y deliciosa!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/order_pizza',
                      arguments: 'Margarita',
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Ordenar Pizza'),
                ),
              ],
            ),
          ),
          // Seccion para pizzas populares (listado en cuadricula con check para ver mas detalles de cada pizza y boton para ordenar)
          const SizedBox(height: 32),
          Text(
            'Pizzas populares',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildPizzaCard(
                context,
                theme,
                colorScheme,
                'Pepperoni',
                'Salsa de tomate, queso mozzarella y pepperoni.',
                190.00,
              ),
              _buildPizzaCard(
                context,
                theme,
                colorScheme,
                'Hawaiana',
                'Salsa de tomate, queso mozzarella, jamón y piña.',
                200.00,
              ),
              _buildPizzaCard(
                context,
                theme,
                colorScheme,
                'Cuatro Quesos',
                'Salsa de tomate, mozzarella, gorgonzola, parmesano y ricotta.',
                249.00,
              ),
              _buildPizzaCard(
                context,
                theme,
                colorScheme,
                'Vegetariana',
                'Salsa de tomate, queso mozzarella y variedad de vegetales.',
                179.00,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
