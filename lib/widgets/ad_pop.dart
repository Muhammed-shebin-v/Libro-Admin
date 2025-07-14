import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro_admin/db/ad.dart';
import 'package:libro_admin/models/ad.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/form.dart';
import 'package:libro_admin/widgets/long_button%20copy.dart';

void showAddAdDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AdPop();
    },
  );
}

class AdPop extends StatelessWidget {
  AdPop({super.key});
  final GlobalKey _formKey = GlobalKey();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final _adService = AdService();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Create New',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Gap(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.color30,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Gap(20),
                    CustomForm(
                      title: 'Title',
                      controller: _titleController,
                      validator: (value) {
                        return null;
                      },
                    ),
                    Gap(5),
                    CustomForm(
                      title: 'Content',
                      controller: _contentController,
                      validator: (value) {
                        return null;
                      },
                    ),
                    Gap(20),
                    CustomLongButton(
                      title: 'Create',
                      ontap: ()async {
                        if(_titleController.text.isNotEmpty&&_contentController.text.isNotEmpty){
                       await _adService.createAd(
                          AdModel(
                            uid: '',
                            title: _titleController.text,
                            content: _contentController.text,
                            imgUrl: '',
                          ),
                        );
                        }
                        Navigator.pop(context);

                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
