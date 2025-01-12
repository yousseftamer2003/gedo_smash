import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food2go_app/models/categories/product_model.dart';

class AddonSelectionWidget extends StatefulWidget {
  const AddonSelectionWidget({
    super.key,
    required this.product,
    required this.mainColor,
    required this.onAddonsChanged,
  });

  final Product product;
  final Color mainColor;
  final Function(List<AddOns>, double) onAddonsChanged;

  @override
  State<AddonSelectionWidget> createState() => _AddonSelectionWidgetState();
}

class _AddonSelectionWidgetState extends State<AddonSelectionWidget> {
  Map<int, int> addonQuantities = {};
  Set<int> selectedAddOnIndices = {};
  List<AddOns> selectedAddons = [];
  double defaultPrice = 0.0;

  @override
  void initState() {
    super.initState();
    defaultPrice = widget.product.price;
    for (int i = 0; i < widget.product.addons.length; i++) {
      addonQuantities[i] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.product.addons.isEmpty
            ? const SizedBox()
            : const Text(
                "Add on order:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
        ...List.generate(
          widget.product.addons.length,
          (index) {
            final addon = widget.product.addons[index];
            final canAdjustQuantity = addon.quantityAdd! > 0;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(addon.name),
                Row(
                  children: [
                    Checkbox(
                      value: selectedAddOnIndices.contains(index),
                      activeColor: widget.mainColor,
                      onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  selectedAddOnIndices.add(index);
                                  addonQuantities[index] = 1;
                                  addon.selectedQuantity = 1;
                                  selectedAddons.add(addon);
                                  widget.product.price += addon.price;
                                } else {
                                  log('${addon.selectedQuantity}');
                                  log('${addon.price * addon.selectedQuantity}');
                                  selectedAddOnIndices.remove(index);
                                  widget.product.price -= addon.price * addon.selectedQuantity;
                                  addonQuantities[index] = 0;
                                  addon.selectedQuantity = 0;
                                  selectedAddons.remove(addon);
                                  widget.product.price -= addon.price * addon.selectedQuantity;
                                }
                                widget.onAddonsChanged(
                                    selectedAddons, widget.product.price);
                              });
                            }
                          
                    ),
                    if (canAdjustQuantity &&
                        selectedAddOnIndices.contains(index))
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (addonQuantities[index]! > 1) {
                                  addonQuantities[index] =
                                      (addonQuantities[index] ?? 1) - 1;
                                  addon.selectedQuantity--;
                                  widget.product.price -= addon.price;
                                  widget.onAddonsChanged(
                                      selectedAddons, widget.product.price);
                                }
                              });
                            },
                          ),
                          Text(addonQuantities[index].toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                  addonQuantities[index] = (addonQuantities[index] ?? 0) + 1;
                                  addon.selectedQuantity++;
                                  widget.product.price += addon.price;
                                  widget.onAddonsChanged(selectedAddons, widget.product.price);
                              });
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
