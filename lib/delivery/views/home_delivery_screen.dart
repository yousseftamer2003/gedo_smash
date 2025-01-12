// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../controllers/delivery/order_provider.dart';
import '../../controllers/delivery/profile_delivery_provider.dart';
import '../../models/delivery/orders_delivery_model.dart';
import 'details_order_delivery_screen.dart';

class HomeDeliveryScreen extends StatefulWidget {
  const HomeDeliveryScreen({super.key});

  @override
  State<HomeDeliveryScreen> createState() => _HomeDeliveryScreenState();
}

class _HomeDeliveryScreenState extends State<HomeDeliveryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderdeliveryProvider>(context, listen: false)
          .fetchOrders(context);

      Provider.of<DeliveryUserProvider>(context, listen: false)
          .fetchUserData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Consumer<DeliveryUserProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.isLoading) {
              return const CircularProgressIndicator();
            }

            return Text(
              "Hello, ${userProvider.user?.firstName ?? 'delivery'}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Active Order",
              style: TextStyle(
                color: maincolor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<OrderdeliveryProvider>(
                builder: (context, orderProvider, child) {
                  if (orderProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (orderProvider.orders.isEmpty) {
                    return const Center(child: Text("No active orders"));
                  }
                  return ListView.builder(
                    itemCount: orderProvider.orders.length,
                    itemBuilder: (context, index) {
                      final order = orderProvider.orders[index];
                      return OrderCard(order: order);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;

  const OrderCard({required this.order, super.key});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isDelivered = true;
  bool _showNotDeliveredOptions = false;
  String? _selectedNotDeliveredOption;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Order Id: #${widget.order.id ?? 'N/A'}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: maincolor, size: 16),
                    const SizedBox(width: 4),
                    Text(widget.order.address?.zone?.zone ??
                        'Address not available'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailsOrderDeliveryScreen(order: widget.order),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: maincolor,
                      ),
                      child: const Text(
                        "View Details",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: maincolor,
                        side: const BorderSide(color: maincolor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Directions"),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildActionButtons(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (widget.order.orderStatus == 'processing') {
      return GestureDetector(
        onTap: () {
          Provider.of<OrderdeliveryProvider>(context, listen: false)
              .updateOrderStatus(context, widget.order.id!, 'out_for_delivery');
          setState(() {
            widget.order.orderStatus = 'out_for_delivery';
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            color: maincolor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: const Center(
            child: Text(
              "Order Received",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    } else if (widget.order.orderStatus == 'out_for_delivery') {
      return _showNotDeliveredOptions
          ? Row(
              children: [
                _buildStatusButton("Failed to Deliver",
                    _selectedNotDeliveredOption == "Failed to Deliver"),
                _buildStatusButton(
                    "Returned", _selectedNotDeliveredOption == "Returned"),
              ],
            )
          : Row(
              children: [
                _buildMainStatusButton("Delivered", _isDelivered, true),
                _buildMainStatusButton("Not Delivered", !_isDelivered, false),
              ],
            );
    }
    return const SizedBox.shrink();
  }

  Widget _buildMainStatusButton(String label, bool isActive, bool isDelivered) {
    if (label == "Delivered") {
      return Expanded(
        child: SwipeButton.expand(
          activeThumbColor: maincolor,
          thumb: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // Calculate the available width
              double thumbWidth = constraints.maxWidth * 0.2;
              double thumbHeight = 40;

              return Container(
                width: thumbWidth,
                height: thumbHeight,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.double_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              );
            },
          ),
          activeTrackColor: maincolor,
          height: 50,
          onSwipe: () async {
            bool? confirm = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  title: const Text(
                    'Confirm Delivery',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: maincolor,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Are you sure you have collected ${widget.order.amount}?',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: maincolor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: maincolor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      ),
                      child: const Text('Confirm'),
                    ),
                  ],
                );
              },
            );

            if (confirm == true) {
              setState(() {
                _isDelivered = true;
                _showNotDeliveredOptions = false;
                _selectedNotDeliveredOption = null;
              });

              await Provider.of<OrderdeliveryProvider>(context, listen: false)
                  .updateOrderStatus(context, widget.order.id!, 'delivered');

              Provider.of<OrderdeliveryProvider>(context, listen: false)
                  .fetchOrders(context);
            }
          },
          child: const Text(
            " Delivered",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else if (label == "Not Delivered") {
      return Expanded(
        child: SwipeButton.expand(
          activeThumbColor: maincolor,
          thumb: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double thumbWidth = constraints.maxWidth * 0.2;
              double thumbHeight = 40;

              return Container(
                width: thumbWidth,
                height: thumbHeight,
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.double_arrow,
                      color: Colors.white,
                    ),
                  ],
                ),
              );
            },
          ),
          activeTrackColor: maincolor,
          height: 50,
          onSwipe: () async {
            bool? confirm = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  title: const Text(
                    'Confirm Not Delivered',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        color: maincolor,
                        size: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Are you sure you want to mark this order as not delivered?',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: maincolor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: maincolor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      ),
                      child: const Text('Confirm'),
                    ),
                  ],
                );
              },
            );

            if (confirm == true) {
              setState(() {
                _isDelivered = false;
                _showNotDeliveredOptions = true;
              });

              await Provider.of<OrderdeliveryProvider>(context, listen: false)
                  .updateOrderStatus(
                      context, widget.order.id!, 'not_delivered');

              Provider.of<OrderdeliveryProvider>(context, listen: false)
                  .fetchOrders(context);
            }
          },
          child: const Text(
            "       Not",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildStatusButton(String label, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedNotDeliveredOption = label;
          });

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final orderStatus =
                label == "Failed to Deliver" ? 'faild_to_deliver' : 'returned';

            await Provider.of<OrderdeliveryProvider>(context, listen: false)
                .updateOrderStatus(context, widget.order.id!, orderStatus);

            Provider.of<OrderdeliveryProvider>(context, listen: false)
                .fetchOrders(context);
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: maincolor),
            color: isActive ? maincolor : Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft:
                  Radius.circular(label == "Failed to Deliver" ? 12 : 0),
              bottomRight: Radius.circular(label == "Returned" ? 12 : 0),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : maincolor,
            ),
          ),
        ),
      ),
    );
  }
}
