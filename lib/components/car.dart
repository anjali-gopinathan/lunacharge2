import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Car extends StatefulWidget {
  const Car({super.key});

  @override
  State<Car> createState() => _CarState();
}

class _CarState extends State<Car> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0x33B57DE1),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xffB57DE1)),
          ),
        ),
        SvgPicture.asset('assets/img/logo.svg', height: 30),
      ],
    );
  }
}
