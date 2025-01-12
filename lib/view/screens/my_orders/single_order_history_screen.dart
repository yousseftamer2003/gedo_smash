import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';

class SingleOrderHistoryScreen extends StatelessWidget {
  const SingleOrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: buildAppBar(context, 'Order #107553'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Order Is Delivered',
                style: TextStyle(color: maincolor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              buildSectionTitle('Delivery Info'),
              buildInfoContainer(
                'From',
                'Smouha',
                'To',
                '6X85+FR9, Street 3B, Ebeet Saad, Sidi Gaber, Alexandria Governorate 5432 080, Egypt',
              ),
              const SizedBox(height: 16),
              buildSectionTitle('Item Info'),
              buildItemInfo(),
              const SizedBox(height: 16),
              buildSectionTitle('Delivery Man'),
              buildDeliveryManInfo(),
              const SizedBox(height: 16),
              buildSectionTitle('Payment Info'),
              buildPaymentInfo(),
              const SizedBox(height: 16),
              buildSectionTitle('Delivery Note'),
              buildDeliveryNote(),
              const SizedBox(height: 16),
              buildPriceDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget buildInfoContainer(
      String labelFrom, String addressFrom, String labelTo, String addressTo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelFrom,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(addressFrom,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            labelTo,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(addressTo, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget buildItemInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        children: [
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text('شيكن شامي مشوي',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('60.00 E£'),
            trailing: Text('X 1'),
          ),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text('شيكن شامي مشوي',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('60.00 E£'),
            trailing: Text('X 1'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Adds On: كومبو ليمن ميت 30.00 E£ (1)',
                style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget buildDeliveryManInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/images/delivery.png')), // Use your own image
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery Man',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text('4.0 ', style: TextStyle(color: Colors.orange)),
                  Icon(Icons.star, color: Colors.orange, size: 16),
                ],
              ),
            ],
          ),
          Spacer(),
          Icon(Icons.message, color: Colors.grey),
          SizedBox(width: 8),
          Icon(Icons.phone, color: Colors.grey),
        ],
      ),
    );
  }

  Widget buildPaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.payment, color: maincolor),
          SizedBox(width: 16),
          Text('Paymob Accept', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget buildDeliveryNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'اكتب ملاحظاتك هنا',
        ),
      ),
    );
  }

  Widget buildPriceDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          buildPriceRow('Items Price', '110.00 E£'),
          buildPriceRow('Addons', '+ 30.00 E£'),
          buildPriceRow('Discount', '- 0.00 E£'),
          buildPriceRow('Vat/Tax', '+ 0.00 E£'),
          buildPriceRow('Coupon Discount', '- 0.00 E£'),
          buildPriceRow('Delivery Fee', '+ 0.00 E£'),
          const Divider(),
          buildPriceRow('Total Amount', '140.00 E£', isTotal: true),
        ],
      ),
    );
  }

  Widget buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(
            amount,
            style: TextStyle(
              color: isTotal ? maincolor : Colors.black,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
