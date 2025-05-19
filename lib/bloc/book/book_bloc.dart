import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libro_admin/bloc/book/book_event.dart';
import 'package:libro_admin/bloc/book/book_state.dart';
import 'package:libro_admin/db/book.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final picker = ImagePicker();
  final cloudinary = CloudinaryPublic(
    'dwzeuyi12',
    'unsigned_uploads',
    cache: false,
  );
  List<XFile> selectedImages = [];
  List<String> uploadedUrls = [];
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
    if (state is BookLoaded) {
      emit(BookLoading());
      try {
        uploadedUrls.clear();

        for (var image in selectedImages) {
          final response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(
              image.path,
              resourceType: CloudinaryResourceType.Image,
            ),
          );
          uploadedUrls.add(response.secureUrl);
        }
        if(uploadedUrls.isNotEmpty) {
        await db.create(event.book,uploadedUrls);
        final books = await db.getBooks();
        emit(BookLoaded(books));
        }
      } catch (e) {
        emit(BookError("Failed to add book: $e"));
      }
    }
  }

  Future<void> _onEditBook(EditBook event, Emitter<BookState> emit) async {
    if (state is BookLoaded) {
      // final currentState = state as BookLoaded;
      emit(BookLoading());
      try {
        await db.updateBook(event.book);
        final books = await db.getBooks();
        emit(BookLoaded(books, selectedBook: event.book));
      } catch (e) {
        emit(BookError(e.toString()));
      }
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

      final books = snapshot.docs.map((doc) => doc.data()).toList();
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

      final books = snapshot.docs.map((doc) => doc.data()).toList();
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

  Future<void> _onPickImages(event, emit) async {
    try {
      final images = await picker.pickMultiImage(limit: 5,requestFullMetadata: false);
      if (images.isNotEmpty) {
         final limitedImages = images.take(5).toList(); // 👈 Limit to 5 images
  selectedImages = limitedImages;
      }
    } catch (e) {
      emit(BookError('Failed to pick images: $e'));
    }
  }
}
