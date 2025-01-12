// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/generated/l10n.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:food2go_app/models/checkout/place_order_model.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../controllers/address/get_address_provider.dart';
import '../../../controllers/checkout/image_provider.dart';
import '../../../controllers/checkout/place_order_provider.dart';
import '../../../models/address/user_address_model.dart';
import '../tabs_screens/screens/profile_screen/add_address_screen.dart'; // Replace this with your actual constants import

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen(
      {super.key,
      required this.cartProducts,
      required this.totalTax,
      required this.totalDiscount});
  final List<Product> cartProducts;
  final double totalTax;
  final double totalDiscount;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int? selectedBranchId;
  int? selectedAdressId;
  String? selectedPaymentMethod;
  String? selectedDeliveryOption;
  String? selectedBranch;
  String? selectedDeliveryLocation;
  bool deliveryNow = true;
  double zonePrice = 0.0;
  bool isChosen = false;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController deliveryTimeController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderTypesAndPaymentsProvider>(context, listen: false)
          .fetchOrderTypesAndPayments(context);
      Provider.of<AddressProvider>(context, listen: false)
          .fetchAddresses(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderTypesAndPaymentsProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    final orderTypes =
        provider.data?.orderTypes.where((type) => type.status == 1).toList() ??
            [];

    final paymentMethods = provider.data?.paymentMethods ?? [];
    final branches = provider.data?.branches ?? [];

    return Scaffold(
      appBar: buildAppBar(context, S.of(context).checkout),
      body: provider.isLoading || addressProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(S.of(context).Choose_Pickup_or_Delivery),
                    const SizedBox(height: 10),
                    Row(
                      children: orderTypes.map((type) {
                        String text;
                        if (type.type == 'take_away') {
                          text = 'Pickup';
                        } else if (type.type == 'dine_in') {
                          text = 'Dine In';
                        } else if (type.type == 'delivery') {
                          text = 'Delivery';
                        } else {
                          text = _capitalize(type.type);
                        }

                        return Expanded(
                          child: _buildDeliveryOptionRadio(
                            type.type,
                            text,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    if (selectedDeliveryOption == 'take_away')
                      _buildNearestBranchCard(branches),
                    if (selectedDeliveryOption == 'delivery')
                      _buildDeliveryLocationCard(addressProvider.addresses),
                    const SizedBox(height: 30),
                    _buildSectionTitle('Payment Method'),
                    const SizedBox(height: 10),
                    Column(
                      children: paymentMethods.map((method) {
                        return _buildPaymentMethodTile(method);
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                    _buildSectionTitle('Note'),
                    const SizedBox(height: 10),
                    _buildNoteInputField(),
                    if (!deliveryNow) ...[
                      const SizedBox(height: 20),
                      _buildSectionTitle('recieving Time'),
                      const SizedBox(height: 10),
                      _buildDeliveryTimePicker(),
                    ],
                    // const SizedBox(height: 10),
                    // _buildDeliveryNowCheckbox(),
                    const SizedBox(height: 30),
                    _buildPlaceOrderButton(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDeliveryLocationCard(List<Address> addresses) {
    double price = 0.0;
    return Column(
      children: [
        ...addresses.map((address) {
          price = address.zone.price;
          return _buildSelectionTile(
              address.id, // Pass the unique id
              address.type,
              '${address.street} building num: ${address.buildingNum} floor num: ${address.floorNum} apartment: ${address.apartment} additional data: ${address.additionalData}',
              selectedAdressId, // Update this to use the unique id
              (value) {
            setState(() {
              selectedDeliveryLocation = address.type; // Update display text
              selectedAdressId = value; // Update selected id
              zonePrice = price;
              isChosen = true;
            });
            log('zone price: $zonePrice');
          }, price);
        }),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              backgroundColor: maincolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddAddressScreen(),
                ),
              );
            },
            child: const Text(
              'Add New Address',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionTile(int id, String? name, String? address,
      int? selectedValue, ValueChanged<int?> onChanged,
      [double? price = 0]) {
    return RadioListTile<int?>(
      subtitle: price == 0
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Delivery fees: +$price EGP',
                    style: TextStyle(
                        color: isChosen ? Colors.white : maincolor,
                        fontSize: 16)),
              ],
            ),
      value: id, // Use id as the unique identifier
      groupValue: selectedValue,
      onChanged: onChanged,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name!,
            style: TextStyle(
              color: selectedValue == id ? Colors.white : maincolor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            address!,
            style: TextStyle(
              color: selectedValue == id ? Colors.white70 : Colors.grey[700],
            ),
          ),
        ],
      ),
      activeColor: maincolor,
      tileColor: selectedValue == id ? maincolor : Colors.white,
      selected: selectedValue == id,
      selectedTileColor: maincolor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    );
  }

  String _capitalize(String input) =>
      input[0].toUpperCase() + input.substring(1);

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: maincolor,
      ),
    );
  }

  Widget _buildDeliveryOptionRadio(String value, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
          value: value,
          activeColor: maincolor,
          groupValue: selectedDeliveryOption,
          onChanged: (String? value) {
            setState(() {
              selectedDeliveryOption = value;
            });
          },
        ),
        Text(text),
      ],
    );
  }

  Widget _buildNearestBranchCard(List<Branch> branches) {
    return Column(
      children: branches.map((branch) {
        return _buildSelectionTile(
          branch.id, // Use branch.id as the unique identifier
          branch.name,
          branch.address,
          selectedBranchId, // Use selectedBranchId for selection tracking
          (value) {
            setState(() {
              selectedBranch = branch.name; // Update the display name
              selectedBranchId = value; // Update the selected ID
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildPaymentMethodTile(PaymentMethod method) {
    final imageServices = Provider.of<ImageServices>(context);

    return Column(
      children: [
        RadioListTile<String>(
          value: method.name,
          groupValue: selectedPaymentMethod,
          onChanged: (String? value) {
            setState(() {
              selectedPaymentMethod = value;
            });
          },
          title: Row(
            children: [
              const Icon(Icons.payment, color: maincolor),
              const SizedBox(width: 10),
              Text(
                method.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          activeColor: maincolor,
        ),
        if (selectedPaymentMethod != null &&
            selectedPaymentMethod != 'cash on delivery' &&
            selectedPaymentMethod != 'paymob' &&
            selectedPaymentMethod == method.name)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upload Receipt',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    await imageServices.pickImage();
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Receipt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maincolor,
                    foregroundColor: Colors.white,
                  ),
                ),
                if (imageServices.image != null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('Receipt uploaded successfully.'),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildNoteInputField() {
    return TextField(
      controller: noteController,
      decoration: InputDecoration(
        hintText: 'Add a note (e.g., delivery instructions)',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildDeliveryTimePicker() {
    String formatTimeOfDay(TimeOfDay time) {
      final int hour = time.hour;
      final int minute = time.minute;

      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }

    return GestureDetector(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            deliveryTimeController.text = formatTimeOfDay(pickedTime);
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: deliveryTimeController,
          decoration: InputDecoration(
            hintText: 'Select recieving time',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }

  // Widget _buildDeliveryNowCheckbox() {
  //   return CheckboxListTile(
  //     value: deliveryNow, // This determines the checked state
  //     onChanged: (bool? value) {
  //       setState(() {
  //         deliveryNow = value!;
  //         if (deliveryNow) {
  //           deliveryTimeController.clear();
  //         }
  //       });
  //     },
  //     title: Text(
  //       'Delivery Now',
  //       style: TextStyle(
  //         color: deliveryNow ? maincolor : Colors.grey[700],
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //     controlAffinity: ListTileControlAffinity.leading,
  //     activeColor: maincolor,
  //   );
  // }

  Widget _buildPlaceOrderButton(BuildContext context) {
    final imageServices = Provider.of<ImageServices>(context, listen: false);

    String formatTimeOfDay(TimeOfDay time) {
      final int hour = time.hour;
      final int minute = time.minute;

      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }

    return ElevatedButton(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        if (selectedPaymentMethod == null || selectedDeliveryOption == null) {
          showTopSnackBar(
              context,
              'Please select a payment method and delivery option',
              Icons.warning_outlined,
              maincolor,
              const Duration(seconds: 4));
          setState(() {
            isLoading = false;
          });
          return;
        }
        if (selectedDeliveryLocation == null) {
          showTopSnackBar(
              context,
              'Please select an address to procced the order',
              Icons.warning_outlined,
              maincolor,
              const Duration(seconds: 4));
          setState(() {
            isLoading = false;
          });
          return;
        }

        if (!deliveryNow && deliveryTimeController.text.isEmpty) {
          showTopSnackBar(
              context,
              'Please select a delivery time',
              Icons.warning_outlined,
              maincolor,
              const Duration(seconds: 3));
          setState(() {
            isLoading = false;
          });
          return;
        }

        try {
          final selectedPayment =
              Provider.of<OrderTypesAndPaymentsProvider>(context, listen: false)
                  .data
                  ?.paymentMethods
                  .firstWhere((method) => method.name == selectedPaymentMethod);

          if (selectedPayment == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('try another payment please')),
            );
            setState(() {
              isLoading = false;
            });
            return;
          }

          final receiptBase64 = imageServices.image != null
              ? imageServices.convertImageToBase64(imageServices.image!)
              : '';

          // Format delivery time
          String deliveryTime = formatTimeOfDay(TimeOfDay.now());
              

          await Provider.of<ProductProvider>(context, listen: false).postCart(
            context,
            products: widget.cartProducts,
            date: deliveryTime,
            branchId: selectedBranchId,
            totalTax: widget.totalTax,
            addressId: selectedAdressId,
            orderType: selectedDeliveryOption!,
            paymentMethodId: selectedPayment.id,
            receipt: receiptBase64,
            notes: noteController.text,
            zonePrice: zonePrice,
            totalDiscount: widget.totalDiscount,
          );
          setState(() {
            isLoading = false;
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: maincolor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                'Place Order',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
