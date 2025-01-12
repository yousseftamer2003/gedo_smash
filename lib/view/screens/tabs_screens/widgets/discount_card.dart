import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:food2go_app/view/screens/cart/product_details_screen.dart';
import 'package:provider/provider.dart';

class DiscountCard extends StatefulWidget {
  const DiscountCard(
      {super.key,
      required this.name,
      required this.image,
      required this.price,
      required this.description,
      this.isFav,
      this.product,
      this.productId});
  final String name;
  final String image;
  final String description;
  final double price;
  final int? productId;
  final bool? isFav;
  final Product? product;

  @override
  State<DiscountCard> createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  bool isFavorite = false;

  @override
  void initState() {
    isFavorite = widget.isFav ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, // Set the width as requested
      height: 180, // Set the height as requested
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // Rounded corners
      ),
      child: Stack(
        children: [
          // Discount Badge
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: maincolor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                '${widget.product!.discount.amount} %',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Favorite Button using Align
          Align(
            alignment: Alignment.topRight,
            child: Consumer<ProductProvider>(
              builder: (context, favProvider, _) {
                return GestureDetector(
                  onTap: () {
                    favProvider.makeFavourites(
                        context, isFavorite ? 0 : 1, widget.productId ?? 0);
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? maincolor : Colors.grey,
                    size: 23,
                  ),
                );
              },
            ),
          ),
          // Product Image
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Image.network(
                  widget.image,
                  height: 60,
                ),
              ],
            ),
          ),
          // Product Info
          Positioned(
            bottom: 40,
            left: 10,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                ),
                Text(
                  widget.description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          ),
          // Price Info
          Positioned(
            bottom: 10,
            left: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.price.toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  "${widget.price}",
                  style: const TextStyle(
                    color: maincolor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Add to Cart Button
          Positioned(
            bottom: 5,
            right: 10,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                              product: widget.product,
                            )));
              },
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: maincolor,
                ),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
