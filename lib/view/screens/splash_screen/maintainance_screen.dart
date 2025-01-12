import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';

class MaintainanceScreen extends StatelessWidget {
  const MaintainanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/maintenance.png'),
            const SizedBox(height: 20),
            const Text(
              'Maintenance in Progress',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Text(
                    'We are currently improving your experience. We will be back soon!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 30),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Please come back Sooner',style: TextStyle(fontSize: 20,color: maincolor),),
          ],
        ),
      ),
    );
  }
}