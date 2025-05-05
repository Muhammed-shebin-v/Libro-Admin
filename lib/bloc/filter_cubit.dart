// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// // Event
// abstract class FilterEvent extends Equatable {
//   const FilterEvent();

//   @override
//   List<Object?> get props => [];
// }

// class FilterSelected extends FilterEvent {
//   final String filter;
//   const FilterSelected(this.filter);

//   @override
//   List<Object?> get props => [filter];
// }

// // State
// class FilterState extends Equatable {
//   final String selectedFilter;

//   const FilterState(this.selectedFilter);

//   @override
//   List<Object?> get props => [selectedFilter];
// }

// // Bloc
// class FilterBloc extends Bloc<FilterEvent, FilterState> {
//   FilterBloc(String initialFilter) : super(FilterState(initialFilter)) {
//     on<FilterSelected>((event, emit) {
//       emit(FilterState(event.filter));
//     });
//   }
// }
