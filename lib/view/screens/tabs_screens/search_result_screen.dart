import 'package:flutter/material.dart';
import 'package:food2go_app/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/view/screens/popular_food/widget/popular_food_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final query = _searchController.text;
      Provider.of<ProductProvider>(context, listen: false).updateSearchQuery(query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
                icon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: S.of(context).search,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ) ,
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          final filteredProducts = productProvider.filteredProducts;

          if (_searchController.text.isEmpty) {
            return const Center(
              child: Text(
                "Start typing to search for products",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          if (filteredProducts.isEmpty) {
            return const Center(
              child: Text(
                "No products found",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 230,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return FoodCard(
                  name: product.name,
                  description: product.description,
                  image: product.image,
                  price: product.price,
                  productId: product.id,
                  isFav: product.isFav,
                  product: product,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
