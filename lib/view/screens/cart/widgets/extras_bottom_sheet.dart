import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:provider/provider.dart';

class ExtrasBottomSheet extends StatefulWidget {
  const ExtrasBottomSheet({
    super.key,
    this.product,
    required this.selectedVariation,
    required this.onSelectedExtras,
    required this.onSelectedExcludes,
  });
  final Product? product;
  final int selectedVariation;
  final Function(List<Extra>) onSelectedExtras;
  final Function(List<Excludes>) onSelectedExcludes;

  @override
  State<ExtrasBottomSheet> createState() => _ExtrasBottomSheetState();
}

class _ExtrasBottomSheetState extends State<ExtrasBottomSheet> {
  Set<int> selectedExtras = {};
  Set<int> selectedExcludes = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.product!.excludes.length; i++) {
      selectedExcludes.add(i);
    }
  }

  double getTotalPrice(List<Extra> extras) {
    double totalPrice = 0.0;
    for (var index in selectedExtras) {
      totalPrice += extras[index].price;
    }
    return totalPrice;
  }

  List<Extra> getSelectedExtras(List<Extra> extras) {
    return selectedExtras.map((index) => extras[index]).toList();
  }

  List<Excludes> getDeselectedExcludes(List<Excludes> excludes) {
    return widget.product!.excludes
        .asMap()
        .entries
        .where((entry) => !selectedExcludes.contains(entry.key))
        .map((entry) => entry.value)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        List<Extra> extras = productProvider.getExtras(widget.product!, widget.selectedVariation);
        final excludes = widget.product!.excludes;

        if (extras.isEmpty) {
          return const Center(
            child: Text(
              'No extras available for this variation.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Extras',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    ...List.generate(
                      extras.length,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: selectedExtras.contains(index),
                                      activeColor: maincolor,
                                      onChanged: (value) {
                                        setState(() {
                                          if (value == true) {
                                            selectedExtras.add(index);
                                          } else {
                                            selectedExtras.remove(index);
                                          }
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      extras[index].name,
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '+${extras[index].price.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Total: \$${getTotalPrice(extras).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: maincolor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Excludes',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    ...List.generate(
                      excludes.length,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                excludes[index].name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Checkbox(
                                value: selectedExcludes.contains(index),
                                activeColor: maincolor,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedExcludes.add(index);
                                    } else {
                                      selectedExcludes.remove(index);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final selectedExtrasList = getSelectedExtras(extras);
                  final deselectedExcludesList = getDeselectedExcludes(excludes);
                  widget.onSelectedExtras(selectedExtrasList);
                  widget.onSelectedExcludes(deselectedExcludesList);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: maincolor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                ),
                child: const Text(
                  'Edit on Order',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
