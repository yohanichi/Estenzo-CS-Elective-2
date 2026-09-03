import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Databytes - simple e-commerce prototype for keyboards & mice
// Implements:
// - Responsive Home grid using GridView.builder and LayoutBuilder
// - Navigation 2.0 using `go_router` (routes defined in `MyApp`)
// - Stateless widgets for static UI (ProductCard, ProductDetail, etc.)
// - Stateful behaviour via `ChangeNotifier` (AppState) and `provider`
// - Theming with a single ThemeData applied at MaterialApp level
// - Light/Dark mode toggle available on the Home screen AppBar
//
// Mapping to exam requirements:
// Home -> ProductDetail -> Add to Cart -> Cart -> Checkout
// - Home: GridView showing products (2 cols phone, 3 cols tablet)
// - ProductDetail: shows image, price, description and Add to Cart
// - Cart: editable quantities, live subtotal via AppState
// - Checkout: accessible only if cart is non-empty (router redirect)

void main() {
  runApp(ChangeNotifierProvider(create: (_) => AppState(), child: const MyApp()));
}

// AppState: central, app-wide mutable state managed with ChangeNotifier.
// - Holds the current `ThemeMode` so the home switch can toggle light/dark.
// - Holds the cart contents and exposes methods to mutate them. These
//   mutations call `notifyListeners()` so UI listening via `Provider`
//   updates automatically (live running totals, quantity updates, etc.).
class AppState extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  final List<CartItem> cart = [];

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void addToCart(Product p) {
    final idx = cart.indexWhere((c) => c.product.id == p.id);
    if (idx >= 0) {
      cart[idx].quantity++;
    } else {
      cart.add(CartItem(product: p, quantity: 1));
    }
    debugPrint('AppState.addToCart: ${p.id}, cartCount=${cart.length}');
    notifyListeners();
  }

  void updateQuantity(String productId, int delta) {
    final idx = cart.indexWhere((c) => c.product.id == productId);
    if (idx == -1) return;
    cart[idx].quantity += delta;
    if (cart[idx].quantity <= 0) cart.removeAt(idx);
    debugPrint('AppState.updateQuantity: $productId delta=$delta, cartCount=${cart.length}');
    notifyListeners();
  }

  double get total => cart.fold(0, (s, c) => s + c.product.price * c.quantity);

  void clearCart() {
    cart.clear();
    debugPrint('AppState.clearCart');
    notifyListeners();
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  Product({required this.id, required this.name, required this.price, required this.imageUrl});
}

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, required this.quantity});
}

// A small catalog of tech peripherals. Kept as in-memory sample data
// for the prelim exam. Each product includes an id, display name,
// price, and an image URL (here using picsum placeholders).
final sampleProducts = <Product>[
  Product(
    id: 'logi_mx_keys',
    name: 'Logitech MX Keys S',
    price: 129.99,
    imageUrl: 'https://ecommerce.datablitz.com.ph/cdn/shop/files/0097855187864.jpg?v=1729251235&width=1000',
  ),
  Product(
    id: 'logi_g502',
    name: 'Logitech G502 Mouse',
    price: 79.99,
    imageUrl: 'https://ecommerce.datablitz.com.ph/cdn/shop/products/5553fbb5f3b790cb5c407e9f353ec675.jpg?v=1676772706',
  ),
  Product(
    id: 'razer_blackwidow',
    name: 'Razer BlackWidow',
    price: 119.99,
    imageUrl: 'https://electroworld.abenson.com/media/catalog/product/1/7/175092_2020.jpg',
  ),
  Product(
    id: 'razer_deathadder',
    name: 'Razer DeathAdder',
    price: 49.99,
    imageUrl: 'https://picsum.photos/seed/razer_deathadder/400/400',
  ),
  Product(
    id: 'corsair_k70',
    name: 'Corsair K70',
    price: 139.99,
    imageUrl: 'https://picsum.photos/seed/corsair_k70/400/400',
  ),
  Product(
    id: 'steelseries_rival',
    name: 'SteelSeries Rival',
    price: 59.99,
    imageUrl: 'https://picsum.photos/seed/steelseries_rival/400/400',
  ),
  Product(
    id: 'keychron_k2',
    name: 'Keychron K2',
    price: 89.99,
    imageUrl: 'https://picsum.photos/seed/keychron_k2/400/400',
  ),
  Product(
    id: 'logi_mx_master',
    name: 'Logitech MX Master',
    price: 99.99,
    imageUrl: 'https://picsum.photos/seed/logitech_mx_master/400/400',
  ),
];

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Build the router once and keep it for the app lifetime. Creating the
    // router on every build caused navigation resets when AppState notified
    // listeners. We use Provider to obtain AppState here and pass it as
    // refreshListenable so GoRouter updates when the cart changes.
    if (_router == null) {
      final appState = Provider.of<AppState>(context);
      _router = GoRouter(
        refreshListenable: appState,
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/product/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final product = sampleProducts.firstWhere((p) => p.id == id);
              return ProductDetail(product: product);
            },
          ),
          GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
          GoRoute(path: '/checkout', builder: (context, state) => const CheckoutScreen()),
        ],
        redirect: (context, state) {
          final appState = Provider.of<AppState>(context, listen: false);
          debugPrint('GoRouter.redirect called, location=${state.location}, cartCount=${appState.cart.length}');
          if (state.location == '/checkout' && appState.cart.isEmpty) return '/cart';
          return null;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return MaterialApp.router(
      title: 'Databytes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: appState.themeMode,
      routerConfig: _router!,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // Home screen scaffold with AppBar. The AppBar contains:
    // - shopping cart shortcut
    // - theme toggle switch for light/dark mode (mutates AppState)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Databytes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => GoRouter.of(context).go('/cart'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Icon(Icons.light_mode, size: 18),
                Switch(
                  value: appState.themeMode == ThemeMode.dark,
                  onChanged: (_) => appState.toggleTheme(),
                ),
                const Icon(Icons.dark_mode, size: 18),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // LayoutBuilder used to adapt layout based on available width.
        // This satisfies the responsive requirement: 2 columns on narrow
        // screens (phones), 3 columns on wider/tablet screens.
        child: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          final columns = width < 600 ? 2 : 3;

          // GridView.builder provides an efficient, scrollable grid of
          // product cards. Each cell uses a Card with an image and text.
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: sampleProducts.length,
            itemBuilder: (context, index) {
              final p = sampleProducts[index];
              return ProductCard(key: ValueKey(p.id), product: p);
            },
          );
        }),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // ProductCard is a StatelessWidget because its internal UI does not
    // change after construction. Tapping the card navigates using go_router.
    // Widgets used:
    // - Card: Material container with elevation and rounded corners.
    // - InkWell: provides tap ripple effect and onTap handling.
    // - AspectRatio + Image.network: ensures square product image.
    // - Text: title and price displayed with theme styles.
    // - Sizedbox - creates spaces.
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => GoRouter.of(context).go('/product/${product.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('\$${product.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetail extends StatelessWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    // ProductDetail shows the product's image, title, and price.
    // It is implemented as a StatelessWidget because it does not hold local
    // mutable UI state; when the user taps "Add to Cart" we mutate global
    // AppState (ChangeNotifier) which will update other listening widgets.
    // Widgets used:
    // - Scaffold + AppBar: consistent app chrome on every screen.
    // - SingleChildScrollView: allows content to scroll on small phones.
    // - ElevatedButton.icon: action to add the product to the cart.
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(aspectRatio: 1, child: Image.network(product.imageUrl, fit: BoxFit.cover)),
              const SizedBox(height: 12),
              Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('\$${product.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              Text('Product details go here. This area can include description, specs, and other useful information.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Add to cart via AppState; AppState notifies listeners so
                  // cart UI updates automatically without ProductDetail holding state.
                  appState.addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Add to Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // Cart screen:
    // - Shows each cart item as a ListTile with image, title, subtotal.
    // - Provides quantity controls using IconButton that call AppState.updateQuantity.
    // - Running total is computed from AppState.total and displayed in the footer.
    // - "Proceed to Checkout" is disabled when the cart is empty.
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: appState.cart.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: appState.cart.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = appState.cart[index];
                      // Add a stable key to the ListTile so Flutter can preserve
                      // widget identity across rebuilds when items are removed
                      // or quantities change. This avoids unexpected UI
                      // behavior during provider notifications.
                      return ListTile(
                        key: ValueKey(item.product.id),
                        leading: Image.network(item.product.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
                        title: Text(item.product.name),
                        subtitle: Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Quantity decrement button
                            IconButton(onPressed: () => appState.updateQuantity(item.product.id, -1), icon: const Icon(Icons.remove_circle_outline)),
                            // Quantity display
                            Text('${item.quantity}'),
                            // Quantity increment button
                            IconButton(onPressed: () => appState.updateQuantity(item.product.id, 1), icon: const Icon(Icons.add_circle_outline)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: Theme.of(context).textTheme.titleLarge),
                      Text('\$${appState.total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: appState.cart.isEmpty ? null : () => GoRouter.of(context).go('/checkout'),
                      child: const Text('Proceed to Checkout'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // Checkout screen displays a read-only summary of items currently in
    // the cart and the final total. The router already prevents direct
    // navigation here if the cart is empty, ensuring the user followed the
    // required flow. Confirming the order clears the cart and returns to
    // the home screen.
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout Confirmation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Order Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: appState.cart.length,
                itemBuilder: (context, index) {
                  final it = appState.cart[index];
                  return ListTile(
                    title: Text(it.product.name),
                    trailing: Text('${it.quantity} x \$${it.product.price.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text('Total: \$${appState.total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm'),
                    content: const Text('Thank you! Your order has been placed.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Clear the cart and return to Home.
                          appState.clearCart();
                          Navigator.of(context).pop();
                          GoRouter.of(context).go('/');
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Confirm Order'),
            ),
          ],
        ),
      ),
    );
  }
}
