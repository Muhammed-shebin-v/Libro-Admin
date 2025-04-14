import 'package:flutter/material.dart';

class CustomLongButton extends StatelessWidget {
  final String title;
  final void Function()? ontap;
  const CustomLongButton({required this.title,required this.ontap, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: InkWell(
        onTap: ontap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.amber,
            border: Border.all(),
            borderRadius: BorderRadius.circular(30),
          ),
          height: 40,
          width: 250,
          child: Align(
            alignment: Alignment.center,
            child: Text(title, style: TextStyle(fontSize: 20)),
          ),
        ),
      ),
    );
  }
}
