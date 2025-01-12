import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';

class PointsCard extends StatelessWidget {
  const PointsCard({
    super.key,
    required this.image,
    required this.title,
    required this.points,
    required this.status,
    required this.onPressed, // Add this
  });

  final String image;
  final String title;
  final int points;
  final int status;
  final VoidCallback onPressed; // Add this

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Trigger the callback when tapped
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(image,fit: BoxFit.cover,)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Container(
                  height: 21,
                  width: status == 0 ? 72 : 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: maincolor),
                    borderRadius: BorderRadius.circular(status == 0 ? 16 : 4),
                    color: status == 0 ? Colors.white : maincolor,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (status == 0)
                          const Icon(
                            Icons.lock,
                            size: 15,
                            color: maincolor,
                          ),
                        Text(
                          '${points.toString()} pts',
                          style: TextStyle(
                            color: status == 0 ? maincolor : Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (status == 0)
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
