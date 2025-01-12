// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/business_setup_controller.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/controllers/tabs_controller.dart';
import 'package:food2go_app/generated/l10n.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:food2go_app/view/screens/checkout/checkout_screen.dart';
import 'package:food2go_app/view/screens/tabs_screens/widgets/closed_wrap_container.dart';
import 'package:provider/provider.dart';

class CartDetailssScreen extends StatefulWidget {
  const CartDetailssScreen({super.key, required this.onBack});
  final Function(int lastIndex) onBack;

  @override
  _CartDetailssScreenState createState() => _CartDetailssScreenState();
}

class _CartDetailssScreenState extends State<CartDetailssScreen> {
  double totalDiscount = 0;
  double originalTotalPrice = 0;

  @override
  void initState() {
    Provider.of<ProductProvider>(context,listen: false).loadCart();
    super.initState();
  }

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
        appBar: AppBar(
          title: Center(child: Text(S.of(context).cart_details)),
          leading: IconButton(
          onPressed: (){
            final tabsProvider = Provider.of<TabsController>(context,listen: false);
            widget.onBack(tabsProvider.prevIndex);
          }, 
          icon: const Icon(Icons.arrow_back)),
        ),
        body: Stack(
          children: [
            Consumer<ProductProvider>(
              builder: (context, cartProvider, _) {
                if (cartProvider.cart.isEmpty) {
                  return  Center(
                    child: Text(S.of(context).no_items_in_cart),
                  );
                } else {
                  originalTotalPrice = 0;
                  totalDiscount = 0;
                  for (var e in cartProvider.cart) {
                    originalTotalPrice += e.product.price;
                  }
                  originalTotalPrice +=
                      cartProvider.getTotalTaxAmount(cartProvider.cart
                          .map(
                            (e) => e.product,
                          )
                          .toList());
                  for (var e in cartProvider.cart) {
                    if (e.product.discountId.isNotEmpty) {
                      double discountAmount = (originalTotalPrice * (e.product.discount.amount / 100));
                      totalDiscount += discountAmount;
                    }
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(
                          cartProvider.cart.length,
                          (index) {
                            final cartItem = cartProvider.cart[index];
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 5,
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          cartItem.product.image,
                                          width: 75, 
                                          height: 71, 
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  cartItem.product.name,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                cartItem.options.isNotEmpty
                                                    ? Text('${cartItem.options.map(
                                                        (e) => e.name,
                                                      )}')
                                                    : const SizedBox()
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Display the original price with an overline if there's a discount
                                                if (cartItem
                                                    .product.discountId.isNotEmpty)
                                                  Text(
                                                    '${S.of(context).Egp}${cartItem.product.price.toString()}',
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                      decoration: TextDecoration.lineThrough, // Adds the overline to original price
                                                    ),
                                                  ),
            
                                                Text(
                                                  cartItem.product.discountId
                                                          .isEmpty
                                                      ? '${S.of(context).Egp}${cartItem.product.price.toString()}'
                                                      : '${S.of(context).Egp}${(cartItem.product.price - (cartItem.product.price * (cartItem.product.discount.amount / 100))).toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    color: maincolor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () => cartProvider.decreaseProductQuantity(index),
                                                icon: const Icon(Icons.remove),
                                              ),
                                              Text(
                                                  cartItem.product.quantity
                                                      .toString(),
                                                  style: const TextStyle(fontSize: 16)),
                                              IconButton(
                                                onPressed: () => cartProvider
                                                    .increaseProductQuantity(index),
                                                icon: const Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              cartProvider.removeFromCart(index);
                                            },
                                            icon: const Icon(Icons.delete,
                                                color: maincolor),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                cartItem.extra.isNotEmpty
                                    ? Column(
                                        children: List.generate(
                                          cartItem.extra.length,
                                          (extraIndex) => Container(
                                            margin: const EdgeInsets.all(16.0),
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      Colors.grey.withOpacity(0.2),
                                                  spreadRadius: 5,
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        cartItem.extra[extraIndex].name,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        cartItem.extra[extraIndex].price.toString(),
                                                        style: const TextStyle(
                                                            color: maincolor,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () => cartProvider
                                                              .decreaseExtraQuantity(
                                                                  index,
                                                                  extraIndex),
                                                          icon: const Icon(Icons.remove),
                                                        ),
                                                        Text(
                                                            cartItem.extra[extraIndex].extraQuantity.toString(),
                                                            style: const TextStyle(fontSize: 16)),
                                                        IconButton(
                                                          onPressed: () => cartProvider.increaseExtraQuantity(index,extraIndex),
                                                          icon: const Icon(Icons.add),
                                                        ),
                                                      ],
                                                    ),
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(Icons.delete,
                                                          color: maincolor),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            );
                          },
                        ),
                        // Order Summary Section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(S.of(context).order_summary,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).total_tax),
                                    Text(
                                        '${cartProvider.getTotalTaxAmount(cartProvider.cart.map(
                                              (e) => e.product,
                                            ).toList())} ${S.of(context).Egp}'),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).total_food),
                                    Text('$originalTotalPrice ${S.of(context).Egp}'),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).discount),
                                    Text('${originalTotalPrice - cartProvider.totalPrice} ${S.of(context).Egp}'),
                                  ],
                                ),
                                const Divider(thickness: 1),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).total,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text('${cartProvider.totalPrice} ${S.of(context).Egp}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: maincolor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 16),
                                    ),
                                    onPressed: () {
                                      List<Product> cartProducts = cartProvider.cart.map(
                                            (e) => e.product,
                                          )
                                          .toList();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CheckoutScreen(
                                                    cartProducts: cartProducts,
                                                    totalTax: cartProvider.getTotalTaxAmount(cartProvider.cart.map(
                                              (e) => e.product,
                                            ).toList()),
                                            totalDiscount: originalTotalPrice - cartProvider.totalPrice,
                                                  )));
                                    },
                                    child:  Text(S.of(context).checkout,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        )
                      ],
                    ),
                  );
                }
              },
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
