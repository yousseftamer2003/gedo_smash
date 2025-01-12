// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/result_screen.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import 'package:food2go_app/controllers/categories/categories_provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double _priceStart = 33;
  double _priceEnd = 200;
  int? _selectedCategoryId; // Store category ID instead of name

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CategoriesProvider>(context, listen: false)
            .fetchCategories(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Filter'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<CategoriesProvider>(
          builder: (context, categoriesProvider, child) {
            final categories = categoriesProvider.categories;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: categories.isNotEmpty
                      ? categories
                          .map((category) =>
                              _buildCategoryChip(category.id, category.name))
                          .toList()
                      : [const CircularProgressIndicator()],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Price',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                RangeSlider(
                  activeColor: maincolor,
                  values: RangeValues(_priceStart, _priceEnd),
                  min: 0,
                  max: 500,
                  divisions: 200,
                  labels: RangeLabels('$_priceStart', '$_priceEnd'),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _priceStart = values.start;
                      _priceEnd = values.end;
                    });
                  },
                ),
                const SizedBox(height: 50),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => ResultScreen(
                            categoryId: _selectedCategoryId, // Pass category ID
                            priceStart: _priceStart,
                            priceEnd: _priceEnd,
                            categoryName: _selectedCategoryId != null
                                ? categories
                                    .firstWhere((category) =>
                                        category.id == _selectedCategoryId)
                                    .name
                                : '', // Get category name from the list of categories
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: maincolor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Done'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChip(int categoryId, String categoryName) {
    return ChoiceChip(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: maincolor),
      ),
      label: Text(categoryName),
      selected: _selectedCategoryId == categoryId,
      onSelected: (bool selected) {
        setState(() {
          _selectedCategoryId = selected ? categoryId : null;
        });
      },
      selectedColor: maincolor,
      labelStyle: TextStyle(
        color: _selectedCategoryId == categoryId ? Colors.white : maincolor,
      ),
      backgroundColor: Colors.white,
    );
  }
}
