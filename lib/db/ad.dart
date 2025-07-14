import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/models/ad.dart';

class AdService{
  final _adRef= FirebaseFirestore.instance.collection('ads');
  Future<List<AdModel>> fetchAds()async{
    try{
      final snapshot =await _adRef.get();
      return snapshot.docs.map((doc) => AdModel.fromMap(doc.data())).toList();
    }catch(e){
      log('$e');
      rethrow;
    }
  }

  Future<void> createAd(AdModel ad)async{
    try{
      _adRef.add(ad.toMap());
      log('Successfully added new ad');
    }catch(e){
      log("$e");
      rethrow;
    }
  }
}