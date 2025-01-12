import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:food2go_app/view/screens/cart/product_details_screen.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'package:provider/provider.dart';

class FoodCard extends StatefulWidget {
  const FoodCard(
      {super.key,
      required this.name,
      required this.image,
      required this.description,
      required this.price,
      this.productId,
      this.isFav,
      this.product});
  final String name;
  final String image;
  final String description;
  final double price;
  final int? productId;
  final bool? isFav;
  final Product? product;
  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool isFavorite = false;

  @override
  void initState() {
    isFavorite = widget.isFav ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    return Container(
      width: 135,
      height: 180, // Set the height as requested
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.product?.discount.amount == 0 ? const SizedBox(width: 5,) : Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: maincolor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                '${widget.product?.discount.amount} %',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                child: Consumer<ProductProvider>(
                  builder: (context, favProvider, _) {
                    return GestureDetector(
                      onTap: () {
                        if(loginProvider.token == null){
                          showTopSnackBar(context, 'You have to login first', Icons.warning_outlined, maincolor, const Duration(seconds: 3));
                          return;
                        }
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
            ],
          ),
          Container(
            height: 71,
            width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200], // Placeholder color
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 98,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.price} EGP',
                        style: const TextStyle(
                          fontSize: 14,
                          color: maincolor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
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
                              color: maincolor),
                          child: const Center(
                            child: Icon(Icons.add, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}