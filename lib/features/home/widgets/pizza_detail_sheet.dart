import 'package:dsage/core/config/app_constants.dart';
import 'package:dsage/shared/widgets/DetailChip.dart';
import 'package:dsage/shared/model/pizza.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PizzaDetailSheet extends StatefulWidget {
  const PizzaDetailSheet({required this.pizza});
  final Pizza pizza;

  @override
  State<PizzaDetailSheet> createState() => _PizzaDetailSheetState();
}

class _PizzaDetailSheetState extends State<PizzaDetailSheet> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final double sheetHeight = MediaQuery.of(context).size.height * 0.82;
    final Pizza pizza = widget.pizza;
    // Precio por unidad (basePrice + toppings) y total con cantidad seleccionada
    final double unitPrice = pizza.copyWith(quantity: 1).totalPrice;
    final double total = pizza.copyWith(quantity: _quantity).totalPrice;

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Contenido desplazable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen grande
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: pizza.imageUrl != null
                          ? Image.network(
                              pizza.imageUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder: (ctx, child, progress) =>
                                  progress == null
                                  ? child
                                  : Container(
                                      color: cs.surfaceContainerHighest,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                              errorBuilder: (_, __, ___) => Container(
                                color: cs.surfaceContainerHighest,
                                child: const Center(
                                  child: Icon(Icons.local_pizza, size: 60),
                                ),
                              ),
                            )
                          : Container(
                              color: cs.surfaceContainerHighest,
                              child: const Center(
                                child: Icon(Icons.local_pizza, size: 60),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nombre y precio
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          pizza.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '\$${unitPrice.toStringAsFixed(0)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Descripción
                  Text(
                    pizza.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Toppings
                  if (pizza.toppings.isNotEmpty) ...[
                    Text(
                      'Ingredientes',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: pizza.toppings
                          .map(
                            (t) => Chip(
                              label: Text(
                                t.description != null
                                    ? '${t.name} · ${t.description}'
                                    : t.name,
                              ),
                              labelStyle: theme.textTheme.labelSmall?.copyWith(
                                color: cs.onPrimaryContainer,
                              ),
                              backgroundColor: cs.primaryContainer.withAlpha(
                                160,
                              ),
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Detalles (tamaño y masa)
                  Row(
                    children: [
                      DetailChip(
                        icon: Icons.straighten,
                        label: pizza.size,
                        theme: theme,
                        cs: cs,
                      ),
                      const SizedBox(width: 10),
                      DetailChip(
                        icon: Icons.layers_outlined,
                        label: pizza.crust,
                        theme: theme,
                        cs: cs,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Selector de cantidad
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cantidad',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              color: cs.onSurface,
                            ),
                            SizedBox(
                              width: 32,
                              child: Text(
                                '$_quantity',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => _quantity++),
                              color: cs.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(color: cs.outlineVariant, width: 0.5),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  final finalPizza = pizza.copyWith(quantity: _quantity);

                  final List<Pizza> items = [finalPizza];
                  final double subtotal = finalPizza.totalPrice;
                  final double tax = subtotal * AppConstants.taxRate;
                  final double shipping = AppConstants.baseShippingCost;

                  Navigator.pop(context);

                  context.push(
                    '/checkout',
                    extra: {
                      'orderId':
                          'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      'items': items,
                      'subtotal': subtotal,
                      'tax': tax,
                      'shippingCost': shipping,
                    },
                  );
                },
                child: Text(
                  'Comprar — \$${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
