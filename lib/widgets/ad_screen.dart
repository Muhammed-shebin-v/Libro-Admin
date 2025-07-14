import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro_admin/bloc/ad/ad_bloc.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/ad.dart';
import 'package:libro_admin/widgets/ad_pop.dart';

class AdScreen extends StatelessWidget {
  const AdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'ADs Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),

                  ElevatedButton.icon(
                    onPressed: () {
                      showAddAdDialog(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add AD'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              BlocBuilder<AdBloc, AdState>(
                builder: (context, state) {
                  if (state is AdLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is AdError) {
                    return Center(child: Text('Something went wrong'));
                  } else if (state is AdLoaded) {
                    if (state.list.isEmpty) {
                      return const Center(child: Text("No ads available"));
                    }

                    return SizedBox(
                      height: 200,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        physics: ScrollPhysics(),
                        itemCount: state.list.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final item = state.list[index];

                            return CustomAd(
                              title: item.title,
                              content: item.content,
                              imgUrl: item.imgUrl,
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(child: Text('error happend'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
