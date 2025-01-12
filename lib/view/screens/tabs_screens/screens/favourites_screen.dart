// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/business_setup_controller.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/generated/l10n.dart';
import 'package:food2go_app/view/screens/popular_food/widget/popular_food_widget.dart';
import 'package:food2go_app/view/screens/tabs_screens/widgets/closed_wrap_container.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    final businessSetupProvider = Provider.of<BusinessSetupController>(context, listen: false);
  String from = businessSetupProvider.from;
  String to = businessSetupProvider.to;

  // Parse the "from" and "to" time slots into DateTime objects
  final now = DateTime.now();
  final fromTime = DateTime(now.year, now.month, now.day,
      int.parse(from.split(':')[0]), int.parse(from.split(':')[1]));
  final toTime = DateTime(now.year, now.month, now.day,
      int.parse(to.split(':')[0]), int.parse(to.split(':')[1]));

  final isClosed = now.isAfter(fromTime) && now.isBefore(toTime);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                    Center(
                    child: Text(
                      S.of(context).favorites,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Consumer<ProductProvider>(
                      builder: (context, productProvider, _) {
                        if (productProvider.favorites.isEmpty) {
                          return  Center(
                            child: Text(S.of(context).no_favorites_yet),
                          );
                        } else {
                          // List to hold widgets
                          List<Widget> contentWidgets = [];
            
                          if (productProvider.favorites.isNotEmpty) {
                            contentWidgets.add(
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  shrinkWrap: true, 
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    mainAxisExtent: 210,
                                  ),
                                  itemCount: productProvider.favorites.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final product =
                                        productProvider.favorites[index];
                                    return FoodCard(
                                      description: product.description,
                                      image: product.image,
                                      name: product.name,
                                      price: product.price,
                                      productId: product.id,
                                      isFav: product.isFav,
                                      product: product,
                                    );
                                  },
                                ),
                              ),
                            );
                          }
            
                          return ListView(
                            children: contentWidgets,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (isClosed) ...[
            GestureDetector(
              onTap: () {}, // Blocks taps on the underlying widgets
              child: Container(
                color: Colors.black.withOpacity(0.6), // Semi-transparent overlay
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Center(
              child: buildClosedWrap(context, from, to),
            ),
          ],
          ],
        ),
      ),
    );
  }
}
