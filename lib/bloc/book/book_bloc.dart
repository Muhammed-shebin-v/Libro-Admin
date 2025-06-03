import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libro_admin/bloc/book/book_event.dart';
import 'package:libro_admin/bloc/book/book_state.dart';
import 'package:libro_admin/db/book.dart';
import 'package:libro_admin/models/book.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final picker = ImagePicker();
  final cloudinary = CloudinaryPublic(
    'dwzeuyi12',
    'unsigned_uploads',
    cache: false,
  );

  List<XFile> selectedImages = [];
  List<String> uploadedUrls = [];
  List<XFile> newSelectedImages = []; // for newly picked images
List<String> existingImageUrls = []; // for already uploaded image URLs
  final db = DataBaseService();

  BookBloc() : super(BookInitial()) {
    on<LoadBooks>(_onLoadBooks);
    on<SelectBook>(_onSelectBook);
    on<DeleteBook>(_onDeleteBook);
    on<EditBook>(_onEditBook);
    on<AddBook>(_onAddBook);
    on<LoadBooksAlphabetical>(_loadAlphabetical);
    on<LoadBooksLatest>(_loadLatest);
    on<SortChanged>(_sortchanged);
    on<PickImagesEvent>(_onPickImages);
    on<LoadBooksByCategory>(_onLoadBooksByCategory);
    on<SearchBooks>(_onSearchBooks);
//     on<LoadBookForEdit>((event, emit) {
//   emit(state.copyWith(imageUrls: event.book.imageUrls ?? []));
// });
    
  }

  Future<void> _onLoadBooks(LoadBooks event, Emitter<BookState> emit) async {
    emit(BookLoading());
    try {
      final bookList = await db.getBooks();
      emit(BookLoaded(bookList));
    } catch (e) {
      emit(BookError("Failed to fetch users: $e"));
    }
  }

  void _onSelectBook(SelectBook event, Emitter<BookState> emit) {
    if (state is BookLoaded) {
      final currentState = state as BookLoaded;
      emit(currentState.copyWith(selectedBook: event.book));
    }
  }

  Future<void> _onDeleteBook(DeleteBook event, Emitter<BookState> emit) async {
    if (state is BookLoaded) {
      // final currentState = state as BookLoaded;
      emit(BookLoading());
      try {
        await db.delete(event.uid);
        final books = await db.getBooks();
        emit(BookLoaded(books));
      } catch (e) {
        emit(BookError(e.toString()));
      }
    }
  }



Future<void> _onAddBook(AddBook event, Emitter<BookState> emit) async {
  emit(BookLoading());
  try {
    if (uploadedUrls.isNotEmpty) {
      await db.create(event.book, uploadedUrls);
      final books = await db.getBooks();
      emit(BookLoaded(books));
      selectedImages.clear();
    }
  } catch (e) {
    emit(BookError("Failed to add book: $e"));
  }
}






 


Future<void> _onEditBook(EditBook event, Emitter<BookState> emit) async {
  emit(BookLoading());
  try {
    // Combine existing URLs (possibly modified by user) + uploaded new ones
    final allImageUrls = [...existingImageUrls, ...uploadedUrls];

    // Attach these to event.book
    final updatedBook = event.book.copyWith(imageUrls: allImageUrls); // Ensure BookModel has `imageUrls`

    await db.updateBook(updatedBook);
    final books = await db.getBooks();
    emit(BookLoaded(books, selectedBook: updatedBook));

    // Reset lists after edit
    existingImageUrls.clear();
    newSelectedImages.clear();
    uploadedUrls.clear();
  } catch (e) {
    emit(BookError(e.toString()));
  }
}















  Future<void> _loadAlphabetical(
    LoadBooksAlphabetical event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('books')
              .orderBy('bookName')
              .get();

      final books =
          snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError('Failed to load books'));
    }
  }

  Future<void> _loadLatest(
    LoadBooksLatest event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('books')
              .orderBy('date', descending: true)
              .get();

      final books =
          snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError('Failed to load books'));
    }
  }

  Future<void> _sortchanged(SortChanged event, Emitter<BookState> emit) async {
    emit(SortState(event.newSort));
    if (event.newSort == 'Alphabetical') {
      add(LoadBooksAlphabetical());
    } else if (event.newSort == 'Latest') {
      add(LoadBooksLatest());
    }
  }


Future<void> _onPickImages(PickImagesEvent event, Emitter<BookState> emit) async {
  try {
    final images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      final limitedImages = images.take(5).toList();
      newSelectedImages.addAll(limitedImages);
      uploadedUrls.clear();

      for (var image in newSelectedImages) {
        final response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, resourceType: CloudinaryResourceType.Image),
        );
        uploadedUrls.add(response.secureUrl);
      }

      // Combine new + existing image URLs
      final allUrls = [...existingImageUrls, ...uploadedUrls];
      emit(BookImagesSelected(allUrls));
    }
  } catch (e) {
    emit(BookError('Failed to pick images: $e'));
  }
}















  Future<void> _onLoadBooksByCategory(
    LoadBooksByCategory event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('books')
              .where('category', isEqualTo: event.categoryName)
              .get();
      final books =
          snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
      log(books.toString());
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError('Failed to load category books: $e'));
    }
  }

  Future<void> _onSearchBooks(
    SearchBooks event,
    Emitter<BookState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(LoadBooks());
    }

    emit(BookLoading());
    try {
      final query = event.query.toLowerCase();
      final snapshot =
          await FirebaseFirestore.instance.collection('books').get();
      final results =
          snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).where((
            data,
          ) {
            final bookName = (data.bookName).toString().toLowerCase();
            final authorName = (data.authorName).toString().toLowerCase();
            return bookName.contains(query) || authorName.contains(query);
          }).toList();
      emit(BookLoaded(results));
    } catch (e) {
      emit(BookError('Error searching books: $e'));
    }
  }
}
