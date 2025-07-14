

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/models/ad.dart';

part 'ad_event.dart';
part 'ad_state.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  AdBloc() : super(AdInitial()) {
    on<FetchAds>(_onFetchAd);
  }
  Future<void> _onFetchAd( FetchAds event, Emitter<AdState> emit)async{
      emit(AdLoading());
      try{
        final snapshot = await FirebaseFirestore.instance.collection('ads').get();
        final ads = snapshot.docs.map((e)=>AdModel.fromMap(e.data())).toList();
        emit(AdLoaded(ads))
;
      }catch(e){
        log('error $e');
        emit(AdError('$e'));
      }
  }
}