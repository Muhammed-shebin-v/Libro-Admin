import 'package:flutter/material.dart';

class CustomCounter extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final double width;
  final int maxLenght;
  const CustomCounter({
    super.key,
    required this.controller,
    required this.title,
    required this.width,
    required this.maxLenght,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        Container(
          width: width,
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFF5DEB3),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(),
          ),
          child: Center(
            child: TextFormField(
                controller: controller,
                style: const TextStyle(fontSize: 15),
                maxLines: 1,
                maxLength: maxLenght,
                decoration: InputDecoration(
                  isDense: true,
                  counterText: '',
                  border: InputBorder.none,
                ),
              ),
          ),
          ),
        
      ],
    );
  }
}
