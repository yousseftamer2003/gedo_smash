import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';

Widget buildClosedWrap(BuildContext context,String from,String to) {
    return Container(
          padding: const EdgeInsets.all(8),
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(
              color: maincolor,
            ),
            child: Row(
              children: [
                const Icon(Icons.lock,color: Colors.white,),
                const Text('Closed ',style: TextStyle(color: Colors.white,fontSize: 20),),
                Text('From: $from To: $to',style: const TextStyle(color: Colors.white),)
              ],
            ),
          );
  }