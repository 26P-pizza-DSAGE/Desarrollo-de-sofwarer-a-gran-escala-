import 'package:dsage/shared/model/user.dart';
import 'package:dsage/features/home/widgets/customize_banner.dart';
import 'package:dsage/features/home/widgets/featured_pizza_card.dart';
import 'package:dsage/features/home/widgets/popular_pizza_card.dart';
import 'package:dsage/features/home/widgets/user_card.dart';
import 'package:dsage/shared/model/pizza.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({required this.user, required this.onPizzaTap});

  final User user;
  final void Function(Pizza) onPizzaTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final Pizza featured = Pizza.catalog.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserCard(user: user, theme: theme, cs: cs),
          const SizedBox(height: 24),

          CustomizeBanner(theme: theme, cs: cs),
          const SizedBox(height: 28),

          Text(
            'Recomendada del día',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          FeaturedPizzaCard(
            pizza: featured,
            theme: theme,
            cs: cs,
            onTap: () => onPizzaTap(featured),
          ),
          const SizedBox(height: 28),

          Text(
            'Pizzas populares',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: Pizza.catalog.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final pizza = Pizza.catalog[index];
              return PopularPizzaCard(
                pizza: pizza,
                theme: theme,
                cs: cs,
                onTap: () => onPizzaTap(pizza),
              );
            },
          ),
        ],
      ),
    );
  }
}
