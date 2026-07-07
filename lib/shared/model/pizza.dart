// ─────────────────────────────────────────────────────────────
// Topping — ingrediente con precio unitario
// ─────────────────────────────────────────────────────────────
class Topping {
  final String name;
  final double price;

  /// Descripción corta opcional, p.ej. "50g", "extra picante".
  final String? description;

  const Topping({
    required this.name,
    required this.price,
    this.description,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'description': description,
      };

  factory Topping.fromMap(Map<String, dynamic> map) => Topping(
        name: map['name'] as String,
        price: (map['price'] as num).toDouble(),
        description: map['description'] as String?,
      );

  @override
  String toString() => description != null ? '$name ($description)' : name;
}

// ─────────────────────────────────────────────────────────────
// Pizza — modelo universal para catálogo y creaciones custom
// ─────────────────────────────────────────────────────────────
class Pizza {
  final String id;
  final String name;
  final String description;

  /// URL de imagen. Puede ser nula en pizzas personalizadas sin foto.
  final String? imageUrl;

  final double basePrice;
  final String size;
  final String crust;
  final List<Topping> toppings;
  final bool isCustom;
  final bool isSavedForLater;

  /// Número de unidades; se usa para el cálculo de [totalPrice].
  final int quantity;

  const Pizza({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.basePrice,
    this.size = 'Mediana',
    this.crust = 'Clásica',
    this.toppings = const [],
    this.isCustom = false,
    this.isSavedForLater = false,
    this.quantity = 1,
  });

  // ── Precio total ─────────────────────────────────────────────
  /// (basePrice + Σ topping.price) × quantity
  double get totalPrice {
    final double toppingsSum =
        toppings.fold(0.0, (sum, t) => sum + t.price);
    return (basePrice + toppingsSum) * quantity;
  }

  // ── Serialización ────────────────────────────────────────────
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'basePrice': basePrice,
        'size': size,
        'crust': crust,
        'toppings': toppings.map((t) => t.toMap()).toList(),
        'isCustom': isCustom,
        'isSavedForLater': isSavedForLater,
        'quantity': quantity,
      };

  factory Pizza.fromMap(Map<String, dynamic> map) => Pizza(
        id: map['id'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        imageUrl: map['imageUrl'] as String?,
        basePrice: (map['basePrice'] as num).toDouble(),
        size: map['size'] as String? ?? 'Mediana',
        crust: map['crust'] as String? ?? 'Clásica',
        toppings: (map['toppings'] as List<dynamic>? ?? [])
            .map((e) => Topping.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList(),
        isCustom: map['isCustom'] as bool? ?? false,
        isSavedForLater: map['isSavedForLater'] as bool? ?? false,
        quantity: map['quantity'] as int? ?? 1,
      );

  // ── Copia ────────────────────────────────────────────────────
  Pizza copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? basePrice,
    String? size,
    String? crust,
    List<Topping>? toppings,
    bool? isCustom,
    bool? isSavedForLater,
    int? quantity,
  }) =>
      Pizza(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        basePrice: basePrice ?? this.basePrice,
        size: size ?? this.size,
        crust: crust ?? this.crust,
        toppings: toppings ?? this.toppings,
        isCustom: isCustom ?? this.isCustom,
        isSavedForLater: isSavedForLater ?? this.isSavedForLater,
        quantity: quantity ?? this.quantity,
      );

  @override
  String toString() =>
      'Pizza(id: $id, name: $name, basePrice: $basePrice, size: $size, '
      'crust: $crust, toppings: $toppings, quantity: $quantity, '
      'totalPrice: ${totalPrice.toStringAsFixed(2)}, isCustom: $isCustom)';

  // ── Catálogo mock ────────────────────────────────────────────
  static const List<Pizza> catalog = [
    Pizza(
      id: 'pepperoni-01',
      name: 'Pepperoni',
      description:
          'Salsa de tomate, queso mozzarella y abundante pepperoni. La favorita de todos.',
      imageUrl:
          'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=800&q=80',
      basePrice: 175.00,
      toppings: [
        Topping(name: 'Salsa de tomate', price: 0),
        Topping(name: 'Mozzarella', price: 0, description: '120g'),
        Topping(name: 'Pepperoni', price: 15, description: '80g'),
      ],
    ),
    Pizza(
      id: 'hawaiana-02',
      name: 'Hawaiana',
      description:
          'Salsa de tomate, queso mozzarella, jamón y piña. Un clásico agridulce.',
      imageUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80',
      basePrice: 175.00,
      toppings: [
        Topping(name: 'Salsa de tomate', price: 0),
        Topping(name: 'Mozzarella', price: 0, description: '120g'),
        Topping(name: 'Jamón', price: 12, description: '60g'),
        Topping(name: 'Piña', price: 8, description: '50g'),
      ],
    ),
    Pizza(
      id: 'cuatro-quesos-03',
      name: 'Cuatro Quesos',
      description:
          'Mozzarella, gorgonzola, parmesano y ricotta sobre base de salsa blanca.',
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&q=80',
      basePrice: 195.00,
      toppings: [
        Topping(name: 'Salsa blanca', price: 0),
        Topping(name: 'Mozzarella', price: 0, description: '80g'),
        Topping(name: 'Gorgonzola', price: 20, description: '40g'),
        Topping(name: 'Parmesano', price: 18, description: '30g'),
        Topping(name: 'Ricotta', price: 16, description: '40g'),
      ],
    ),
    Pizza(
      id: 'vegetariana-04',
      name: 'Vegetariana',
      description:
          'Salsa de tomate, mozzarella y una variedad de vegetales frescos de temporada.',
      imageUrl:
          'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800&q=80',
      basePrice: 165.00,
      toppings: [
        Topping(name: 'Salsa de tomate', price: 0),
        Topping(name: 'Mozzarella', price: 0, description: '120g'),
        Topping(name: 'Pimientos', price: 8, description: '40g'),
        Topping(name: 'Champiñones', price: 10, description: '50g'),
        Topping(name: 'Cebolla', price: 5, description: '30g'),
      ],
    ),
  ];
}
