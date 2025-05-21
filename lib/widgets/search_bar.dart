import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:libro_admin/bloc/searchBook/search_bloc.dart';
import 'package:libro_admin/bloc/searchBook/search_event.dart';
import 'package:libro_admin/bloc/searchBook/search_state.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onchanged;
  const CustomSearchBar({super.key,required this.controller,required this.onchanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SearchBar(
                    controller: controller,
                    shadowColor: WidgetStateProperty.all(Colors.transparent),
                    backgroundColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 223, 220, 220),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    leading: Icon(Icons.search),
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 15),
                    ),
                    onChanged: onchanged,
                  ),
                ),
              ],
            ),
          ),

          
        ],
      ),
    );
  }
}
