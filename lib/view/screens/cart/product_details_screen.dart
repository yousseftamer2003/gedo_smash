import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:food2go_app/view/screens/cart/widgets/addon_selection_widget.dart';
import 'package:food2go_app/view/screens/cart/widgets/extras_bottom_sheet.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'package:provider/provider.dart';

import '../tabs_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, this.product});
  final Product? product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  bool isFavorited = false;
  int? selectedVariation;
  Set<String> selectedOptions = {};
  Map<String, String?> selectedOptionsPerVariation = {};
  double defaultPrice = 0;
  List<Extra> selectedExtrasList = [];
  List<Excludes> selectedExcludesList = [];
  List<Option> selectedOptionsObject = [];
  List<Variation> selectedVariations = [];
  List<AddOns> addons = [];

  @override
  void initState() {
    defaultPrice = widget.product!.price;
    super.initState();
  }

  void increaseQuantity() {
    setState(() {
      quantity++;
      widget.product!.quantity++;
      widget.product!.price += defaultPrice;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        widget.product!.quantity--;
        widget.product!.price -= defaultPrice;
      });
    }
  }

  void updatePrice(List<AddOns> selectedAddons, double updatedPrice) {
    setState(() {
      widget.product!.price = updatedPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: HeaderClipper(),
                  child: Container(
                    height: 450,
                    color: maincolor,
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        "Cart",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? maincolor : Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorited = !isFavorited;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircleAvatar(
                      radius: 120,
                      child: ClipOval(
                        child: Image.network(
                          widget.product!.image,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.product!.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2, // Limit to 2 lines
                          overflow: TextOverflow.ellipsis, // Show ellipsis if text exceeds 2 lines
                          softWrap: true, // Allow wrapping to the next line
                        ),
                      ),
                      Text(
                        widget.product!.price.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          color: maincolor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ...List.generate(
                    widget.product!.variations.length,
                    (index) {
                      final variation = widget.product!.variations[index];
                      final isMultipleSelection = variation.type == 'multiple';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            variation.name,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                variation.options.length,
                                (j) {
                                  final option = variation.options[j];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isMultipleSelection) {
                                          if (selectedOptions.contains(option.name)) {
                                            selectedOptions.remove(option.name);
                                            selectedOptionsObject.remove(option);
                                            widget.product!.price -= option.price * quantity;
                                            defaultPrice -= option.price;
                                          } else {
                                            selectedOptions.add(option.name);
                                            selectedOptionsObject.add(option);
                                            selectedVariations.add(variation);
                                            widget.product!.price += option.price * quantity;
                                            defaultPrice += option.price;
                                          }
                                        } else {
                                          final previousSelection = selectedOptionsPerVariation[variation.name];
                                          if (previousSelection == option.name) {
                                            selectedOptionsPerVariation[variation.name] = null;
                                            selectedOptionsObject.remove(option);
                                            widget.product!.price -= option.price * quantity;
                                            defaultPrice -= option.price;
                                          } else {
                                            if (previousSelection  != null) {
                                              Option? previousOption = variation.options.any((opt) => opt.name == previousSelection )
                                              ? variation.options.firstWhere((opt) => opt.name == previousSelection )
                                              : null;
                                              if (previousOption != null) {
                                                widget.product!.price -= previousOption.price * quantity;
                                                defaultPrice -= previousOption.price;
                                                selectedOptionsObject.remove(previousOption);
                                                selectedVariations.remove(variation);
                                              }
                                            }
                                            selectedOptionsObject.add(option);
                                            selectedVariations.add(variation);
                                            selectedOptionsPerVariation[variation.name] = option.name;
                                            widget.product!.price += option.price * quantity;
                                            defaultPrice += option.price;
                                          }
                                        }
                                      });
                                    },
                                    child: SizeOption(
                                      text: option.name,
                                      isSelected: isMultipleSelection? selectedOptions.contains(option.name)
                                          : selectedOptionsPerVariation[variation.name] == option.name,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Ingredients:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            showDragHandle: true,
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                            builder: (context) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: ExtrasBottomSheet(
                                  product: widget.product,
                                  selectedVariation: selectedVariation ?? -1,
                                  onSelectedExtras: (selectedExtras) {
                                    selectedExtrasList = selectedExtras;
                                  },
                                  onSelectedExcludes: (selectedExcludes) {
                                    selectedExcludesList = selectedExcludes;
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: maincolor,
                            ),
                            Text(
                              'extra & excludes',
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: maincolor),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(widget.product!.description),
                  const SizedBox(height: 8),
                  AddonSelectionWidget(
                    product: widget.product!,
                    mainColor: maincolor,
                    onAddonsChanged: (selectedAddons, updatedPrice) {
                      updatePrice(selectedAddons, updatedPrice);
                      setState(() {
                        addons = selectedAddons;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: decreaseQuantity,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            "$quantity",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: increaseQuantity,
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                      Consumer<ProductProvider>(
                        builder: (context, productProvider, _) {
                          return ElevatedButton(
                            onPressed: () {
                              if(loginProvider.token == null){
                                showTopSnackBar(context, 'You have to login first', Icons.warning_outlined, maincolor, const Duration(seconds: 3));
                                return;
                              }
                              Product selectedProduct = widget.product!;
                              selectedProduct.addons = addons;
                              selectedProduct.extra = selectedExtrasList;
                              for (var e in selectedVariations) {
                                e.options = selectedOptionsObject.where((option) => option.variationId == e.id).toList();
                              }
                              selectedProduct.variations = selectedVariations;
                              selectedProduct.excludes = selectedExcludesList;
                              productProvider.addToCart(
                                selectedProduct,
                                selectedExtrasList,
                                selectedOptionsObject,
                                addons,
                                selectedExcludesList,
                              );

                              // Show Dialog
                              showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: const Text('Item Added to Cart'),
                                    content: const Text(
                                        'What would you like to do next?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>const TabsScreen(initialIndex: 0,),
                                            ),
                                          );
                                        },
                                        child: const Text('Continue',style: TextStyle(color: maincolor)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>const TabsScreen(initialIndex: 2,),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: maincolor,
                                          foregroundColor: Colors.white
                                        ),
                                        child: const Text('CheckOut'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 32),
                              backgroundColor: maincolor,
                            ),
                            child: const Text(
                              "Add to Cart",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100);
    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 100);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SizeOption extends StatelessWidget {
  final String text;
  final bool isSelected;

  const SizeOption({super.key, required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? maincolor : Colors.transparent,
          border: Border.all(color: maincolor),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : maincolor,
          ),
        ),
      ),
    );
  }
}
