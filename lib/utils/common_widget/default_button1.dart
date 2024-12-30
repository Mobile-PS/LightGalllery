import 'package:flutter/material.dart';

import '../constant/const_color.dart';

class DefaultButton1 extends StatelessWidget {
  const DefaultButton1({Key? key, this.text, this.press, this.height, required this.background, required this.textcolor})
      : super(key: key);
  final String? text;
  final double? height;
  final Function? press;
  final Color background;
  final Color textcolor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => press!(),
        child: Container(
          height: height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                background,
                background,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text!,
                style: TextStyle(
                    color: textcolor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ));
  }
}
