import 'package:dsage/db/helpers/user.dart';
import 'package:dsage/db/model/user.dart';
import 'package:dsage/services/auth_service.dart';
import 'package:flutter/material.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final RegExp _emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  bool _attemptedSubmit = false;
  bool _isSubmitting = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _passwordController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    final String v = (value ?? '').trim();
    if (v.isEmpty) return 'Ingresa tu nombre de usuario';
    if (v.length < 3) return 'Debe tener al menos 3 caracteres';
    return null;
  }

  String? _validateEmail(String? value) {
    final String v = (value ?? '').trim();
    if (v.isEmpty) return 'Ingresa tu correo electrónico';
    if (!_emailRegExp.hasMatch(v)) return 'Correo electrónico no válido';
    return null;
  }

  String? _validatePassword(String? value) {
    final String v = value ?? '';
    if (v.isEmpty) return 'Ingresa tu contraseña';
    if (v.length < 6) return 'Debe tener al menos 6 caracteres';
    return null;
  }

  void _onFormChanged() {
    final bool next =
        _validateUsername(_usernameController.text) == null &&
        _validateEmail(_emailController.text) == null &&
        _validatePassword(_passwordController.text) == null;
    if (_isFormValid != next) setState(() => _isFormValid = next);
  }

  Future<void> _submitRegistration() async {
    FocusScope.of(context).unfocus();
    setState(() => _attemptedSubmit = true);

    if (!(_formKey.currentState?.validate() ?? false) || _isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      final String email = _emailController.text.trim().toLowerCase();

      final existingUser = UserRepository.instance.getUserByEmail(email);
      if (!mounted) return;

      if (existingUser != null) {
        await _showDialog(
          title: 'Correo en uso',
          content:
              'Ya existe una cuenta con ese correo. Inicia sesión o usa otro.',
        );
        return;
      }

      final int newUserId = await UserRepository.instance.insertUser(
        User(
          username: _usernameController.text.trim(),
          role: Role.user,
          email: email,
          password: _passwordController.text,
        ),
      );

      await AuthService.saveUserId(newUserId);
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } catch (_) {
      if (!mounted) return;
      await _showDialog(
        title: 'Error al registrarse',
        content: 'No fue posible crear tu cuenta. Inténtalo nuevamente.',
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _showDialog({
    required String title,
    required String content,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [theme.scaffoldBackgroundColor, cs.surface],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.local_pizza, size: 80, color: cs.primary),
                    const SizedBox(height: 14),
                    Text(
                      '¡Únete a Pizza Builder!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.onSurface,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Crea tu cuenta y empieza a pedir ahora',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 32),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: cs.outlineVariant),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(110),
                            blurRadius: 32,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _attemptedSubmit
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Crea tu perfil',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Completa tus datos para comenzar',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),

                            const SizedBox(height: 24),

                            TextFormField(
                              controller: _usernameController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Nombre de usuario',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: _validateUsername,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Correo electrónico',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                labelText: 'Contraseña',
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                              validator: _validatePassword,
                              onFieldSubmitted: (_) => _submitRegistration(),
                            ),

                            const SizedBox(height: 28),

                            SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: (!_isFormValid || _isSubmitting)
                                    ? null
                                    : _submitRegistration,
                                child: _isSubmitting
                                    ? SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                cs.onPrimary,
                                              ),
                                        ),
                                      )
                                    : const Text('Registrarse'),
                              ),
                            ),

                            const SizedBox(height: 14),

                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                context,
                                '/login',
                              ),
                              child: Text.rich(
                                TextSpan(
                                  text: '¿Ya tienes cuenta? ',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Inicia sesión aquí',
                                      style: TextStyle(
                                        color: cs.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
