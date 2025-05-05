import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/books_list.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: SafeArea(child: 
      SingleChildScrollView(
        child: Padding(padding: 
        EdgeInsets.all(20),
        child: Column(
          children: [
           SizedBox(
            height: 80,
             child: ListView.separated(
              separatorBuilder: (context,index)=>
              Gap(MediaQuery.of(context).size.width * 0.03,),
              itemCount: 4,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.18,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 220, 214, 214),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all()
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(image: AssetImage('lib/assets/IMG_0899.JPG'),height: 50,),
                            Text('200'),
                            Text('Total users +2.5')
                          ],
                        ),                     
                      ],
                    ),
                  )
                );
              },
             ),
           ),
           Gap(30),
           Row(
             children: [
               Flexible(
                flex: 6,
                 child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 225, 220, 220),
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)
                  
                  ),
                  child: Text("Today Borrows"),
                 ),
               ),
               Gap(20),
                Flexible(
                  flex: 4,
                  child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 225, 220, 220),
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)
                  
                  ),
                  child: Text("Borrow Graph"),
                                 ),
                ),
             ],
           ),
           Gap(20),
           Container(
            height: 300,
            color: const Color.fromARGB(255, 255, 255, 255),
            width: double.infinity,
            child: BooksList(title: 'Books of the week', books: books, images: images, authors: authors, gonores: gonores, colors: colors),
           ),
           Gap(20),
           Row(
             children: [
               Flexible(
                flex: 4,
                 child: Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 225, 220, 220),
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)
                        
                        ),
                        child: Text("Fine Graph"),
                                       ),
               ),
               Gap(20),
               Flexible(
                flex: 6,
                 child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 225, 220, 220),
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)
                  
                  ),
                  child: Text("Today Fines"),
                 ),
               ),
               Gap(20),
             ],
           ),
          ],
        ),),
      )),
    );
  }
  final List<String> books = [
    'The Design of Books',
    'My Book cover',
    'A Teaspoon Earth',
    'The Graphic Design Bible',
    'The Way of the Nameless',
  ];

  final List<String> images = [
    'lib/assets/images.png',
    'lib/assets/book-covers-big-2019101610.jpg',
    'lib/assets/images.jpeg',
    'lib/assets/71ng-giA8bL._AC_UF1000,1000_QL80_.jpg',
    'lib/assets/teal-and-orange-fantasy-book-cover-design-template-056106feb952bdfb7bfd16b4f9325c11.jpg',
  ];

  final List<String> authors = [
    'Bebble Benze',
    'My name',
    'Dina Nayeri',
    'Theio Iglis',
    'Graham Douglass ',
  ];

  final List<String> gonores = [
    'Architecture',
    'History',
    'Biodata',
    'Novel',
    'Fictional',
  ];

  final colors = [
    Colors.red,
    const Color.fromARGB(255, 238, 70, 41),
    const Color.fromARGB(255, 10, 167, 195),
    const Color.fromARGB(255, 248, 108, 53),
    const Color.fromARGB(255, 216, 112, 181),
  ];
}