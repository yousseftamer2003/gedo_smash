import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';

AppBar buildAppBar(BuildContext context, String title){
  return AppBar(
    title: Text(title,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w600),),
    centerTitle: true,
    leading: GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: 32,
        width: 32,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(child: Icon(Icons.arrow_back_ios,color: maincolor,)),
      ),
    ),
  );
}