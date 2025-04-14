import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreListView extends StatelessWidget {
  final CollectionReference books = FirebaseFirestore.instance.collection('books');

 Future<List<QueryDocumentSnapshot>> fetchStudents() async {
  try {
    QuerySnapshot snapshot = await books.get();
    
    // Debugging: Print total document count
    log("📌 Total documents: ${snapshot.docs.length}");

    // Debugging: Print each document's data
    for (var doc in snapshot.docs) {
      log("📝 Document ID: ${doc.id}");
      log("📄 Data: ${doc.data()}");
    }

    return snapshot.docs;
  } catch (e) {
    log("❌ Error fetching data: $e");
    return [];
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Students List')),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: fetchStudents(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No studentssss found"));
          }

          var studentDocs = snapshot.data!;

          return Container(
            height: 700,
            child: ListView.builder(
              itemCount: studentDocs.length,
              itemBuilder: (context, index) {
                var student = studentDocs[index].data() as Map<String, dynamic>;
            
                return ListTile(
                  title: Text(student['bookname'] ?? 'No Name'),
                  subtitle: Text("Age: ${student['bookid'] ?? 'Unknown'}"),
                  trailing: Text("Grade: ${student['authername'] ?? 'N/A'}"),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
