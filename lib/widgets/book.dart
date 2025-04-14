import 'package:flutter/material.dart';

class Book extends StatelessWidget {
  final String image;
  final Color color;
  const Book({super.key,required this.image,required this.color});

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          Container(
              width: 80,
              height: 110,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 72,
                      height: 95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Image(image: AssetImage(image),fit: BoxFit.fill,),
                    ),
                  ),
                  Positioned(
                    bottom: 3,
                    right: 0,
                    child: Container(
                      width: 74,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      
    );
  }
}
