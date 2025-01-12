import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/categories/categories_provider.dart';
import 'package:food2go_app/view/screens/categories/widgets/category_card.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

import '../../tabs_screens/screens/category_details_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Category'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<CategoriesProvider>(
          builder: (context, categoryProvider, _) {
            if (categoryProvider.categories.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: maincolor),
              );
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: categoryProvider.categories.length,
                itemBuilder: (context, index) {
                  final category = categoryProvider.categories[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailsScreen(
                            category: category,
                          ),
                        ),
                      );
                    },
                    child: CategoryCard(
                      text: category.name,
                      image: category.imageLink,
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
