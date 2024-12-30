import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:light_gallery/task/add_task.dart';

import '../utils/constant/const_color.dart';

class Commingscreen extends StatefulWidget {
  @override
  _Commingscreen createState() => _Commingscreen();
}

class _Commingscreen extends State<Commingscreen> {
//  final con = Get.put(QuotesPageController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: backgroundcolor1,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
            child: Icon(Icons.add),
            backgroundColor: primaryColor,
            onPressed: () {
              Get.to(AddTaskscreen());
            }),
    body:Column(
      children: [

        Expanded(child:
      Center(
                      child: Text(
                        'Coming Soon.. !',
                      )))],));


  }
}
