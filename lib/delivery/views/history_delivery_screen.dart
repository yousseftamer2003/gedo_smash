import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:provider/provider.dart';

import '../../controllers/delivery/history_delivery_provider.dart';

class HistoryDeliveryScreen extends StatefulWidget {
  const HistoryDeliveryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HistoryDeliveryScreenState createState() => _HistoryDeliveryScreenState();
}

class _HistoryDeliveryScreenState extends State<HistoryDeliveryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrderHistory();
    });
  }

  void _fetchOrderHistory() {
    final orderHistoryProvider =
        Provider.of<OrderHistoryProvider>(context, listen: false);
    orderHistoryProvider.fetchOrderHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<OrderHistoryProvider>(
        builder: (context, orderHistoryProvider, child) {
          if (orderHistoryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderHistoryProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                orderHistoryProvider.errorMessage,
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }

          final orderHistory = orderHistoryProvider.orderHistory?.orders ?? [];

          if (orderHistory.isEmpty) {
            return const Center(
              child: Text(
                'No history for delivery',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orderHistory.length,
            itemBuilder: (context, index) {
              final order = orderHistory[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Id: #${order.id}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status: ${order.orderStatus}',
                            style: TextStyle(
                              fontSize: 16,
                              color: (order.orderStatus == 'confirmed' ||
                                      order.orderStatus == 'delivered')
                                  ? Colors.green
                                  : maincolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${order.amount} LE',
                            style: const TextStyle(
                              fontSize: 16,
                              color: maincolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Order At ${order.date}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
