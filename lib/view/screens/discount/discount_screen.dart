import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/view/screens/popular_food/widget/popular_food_widget.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class DiscountScreen extends StatelessWidget {
  const DiscountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Discount'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, _) {
            if (productProvider.discounts.isEmpty) {
              return const Center(
                child: Text(
                  'No discount items available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: productProvider.discounts.length,
              itemBuilder: (context, index) {
                final product = productProvider.discounts[index];
                return FoodCard(
                  name: product.name,
                  image: product.image,
                  description: product.description,
                  price: product.price,
                  isFav: product.isFav,
                  product: product,
                  productId: product.id,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
