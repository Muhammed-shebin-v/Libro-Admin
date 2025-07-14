import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:libro_admin/db/borrowed_user.dart';
import 'package:libro_admin/themes/fonts.dart';

class Borroweduser extends StatelessWidget {
  final BorrowedUserInfo userInfo;
  const Borroweduser({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.color60,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(userInfo.imgUrl, fit: BoxFit.fitHeight),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(userInfo.userName, style: AppFonts.heading3),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color:
                            userInfo.status == 'borrowed'
                                ? AppColors.color10
                                : AppColors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),

                      child: Text(userInfo.status, style: AppFonts.body2),
                    ),
                  ],
                ),
                Text(userInfo.userEmail, style: AppFonts.body2),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Borrow:${DateFormat('dd-MM-yyyy').format(userInfo.borrowDate.toLocal())}",
                    ),
                    Gap(5),
                    Text(
                      "Return:${DateFormat('dd-MM-yyyy').format(userInfo.returnDate)}",
                    ),
                  ],
                ),

                Gap(5),
                Text('Fine: ${userInfo.fine}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
