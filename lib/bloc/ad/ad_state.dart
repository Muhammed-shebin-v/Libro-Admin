part of 'ad_bloc.dart';

abstract class AdState{
  const AdState();
}

final class AdInitial extends AdState {}
final class AdLoading extends AdState{}
final class AdLoaded extends AdState{
    final List<AdModel> list;
  AdLoaded(this.list);
}
final class AdError extends AdState{
    final String message;
  AdError(this.message);
}
