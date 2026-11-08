import 'package:cs_elective_2/models/product.dart';
import 'package:cs_elective_2/models/product_filter.dart';
import 'package:cs_elective_2/pages/add_product.dart';
import 'package:cs_elective_2/providers/category_provider.dart';
import 'package:cs_elective_2/providers/product_filter_provider.dart';
import 'package:cs_elective_2/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  RangeValues? _currentPriceRange;
  bool _showFilterPanel = true;

  Future<void> confirmDelete(Product p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${p.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await ref.read(productProvider.notifier).deleteProduct(p.id);
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product deleted')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  void editProduct(Product p) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddProductPage(product: p)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productProvider);
    final filter = ref.watch(productFilterProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    final currentRange =
        _currentPriceRange ?? RangeValues(filter.minPrice, filter.maxPrice);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            tooltip: _showFilterPanel ? 'Hide Filters' : 'Show Filters',
            icon: Icon(
              _showFilterPanel ? Icons.filter_alt : Icons.filter_alt_outlined,
            ),
            onPressed: () {
              setState(() {
                _showFilterPanel = !_showFilterPanel;
              });
            },
          ),
          IconButton(icon: const Icon(Icons.shopping_bag), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddProductPage()),
        ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Filter Panel: Price Slider & Category Filter
          if (_showFilterPanel)
            Card(
              margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.tune,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Price Filter',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        if (filter.isPriceFiltered || filter.categoryId != null)
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                            icon: const Icon(Icons.restart_alt, size: 16),
                            label: const Text('Reset'),
                            onPressed: () {
                              setState(() {
                                _currentPriceRange = const RangeValues(
                                  ProductFilter.defaultMinPrice,
                                  ProductFilter.defaultMaxPrice,
                                );
                              });
                              ref
                                  .read(productFilterProvider.notifier)
                                  .resetFilters();
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Range: ₱${currentRange.start.toStringAsFixed(0)} - ₱${currentRange.end.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          '(Max: ₱${ProductFilter.defaultMaxPrice.toStringAsFixed(0)})',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: currentRange,
                      min: ProductFilter.defaultMinPrice,
                      max: ProductFilter.defaultMaxPrice,
                      divisions: 100,
                      labels: RangeLabels(
                        '₱${currentRange.start.toStringAsFixed(0)}',
                        '₱${currentRange.end.toStringAsFixed(0)}',
                      ),
                      onChanged: (values) {
                        setState(() {
                          _currentPriceRange = values;
                        });
                      },
                      onChangeEnd: (values) {
                        ref
                            .read(productFilterProvider.notifier)
                            .setPriceRange(values.start, values.end);
                      },
                    ),

                    // Category Filter Chips
                    categoriesAsync.when(
                      data: (categories) {
                        if (categories.isEmpty) return const SizedBox.shrink();
                        return SizedBox(
                          height: 36,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: ChoiceChip(
                                  label: const Text('All'),
                                  selected: filter.categoryId == null,
                                  onSelected: (_) {
                                    ref
                                        .read(productFilterProvider.notifier)
                                        .setCategory(null);
                                  },
                                ),
                              ),
                              ...categories.map((c) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: ChoiceChip(
                                    label: Text(c.name),
                                    selected: filter.categoryId == c.id,
                                    onSelected: (selected) {
                                      ref
                                          .read(productFilterProvider.notifier)
                                          .setCategory(selected ? c.id : null);
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

          // Main Product Grid & Empty/Loading/Error states
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text('Error: $e', textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(productProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (response) {
                final products = response.products;
                if (products.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No products match your filter criteria',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Price: ₱${currentRange.start.toStringAsFixed(0)} - ₱${currentRange.end.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset Filters'),
                            onPressed: () {
                              setState(() {
                                _currentPriceRange = const RangeValues(
                                  ProductFilter.defaultMinPrice,
                                  ProductFilter.defaultMaxPrice,
                                );
                              });
                              ref
                                  .read(productFilterProvider.notifier)
                                  .resetFilters();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(productProvider);
                    await ref.read(productProvider.future);
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.78,
                        ),
                    itemCount: products.length,
                    itemBuilder: (_, i) {
                      final p = products[i];
                      return Card(
                        elevation: i % 2 == 0 ? 4 : 2,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Expanded(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  p.imageUrl != null && p.imageUrl!.isNotEmpty
                                      ? Image.network(
                                          p.imageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) =>
                                              const Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  size: 40,
                                                ),
                                              ),
                                          loadingBuilder:
                                              (context, child, progress) {
                                                if (progress == null) {
                                                  return child;
                                                }
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                        )
                                      : const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 40,
                                          ),
                                        ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.white70,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            iconSize: 20,
                                            icon: const Icon(Icons.edit),
                                            onPressed: () => editProduct(p),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.white70,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            iconSize: 20,
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.redAccent,
                                            ),
                                            onPressed: () => confirmDelete(p),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₱${p.price.toStringAsFixed(2)}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (p.stock < 5)
                                    const Text(
                                      'Low stock',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Pagination Bar (Supabase Query Pagination)
          productsAsync.maybeWhen(
            data: (response) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border(
                    top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      icon: const Icon(Icons.chevron_left),
                      label: const Text('Prev'),
                      onPressed: response.hasPrevPage
                          ? () => ref
                                .read(productFilterProvider.notifier)
                                .prevPage()
                          : null,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Page ${response.page} of ${response.totalPages > 0 ? response.totalPages : 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${response.totalCount} products total',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      icon: const Icon(Icons.chevron_right),
                      label: const Text('Next'),
                      onPressed: response.hasNextPage
                          ? () => ref
                                .read(productFilterProvider.notifier)
                                .nextPage()
                          : null,
                    ),
                  ],
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
