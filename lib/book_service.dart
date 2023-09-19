import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Book {
  String title;
  String imageLink;
  String infoLink;

  Book({required this.title, required this.imageLink, required this.infoLink});
}

class BookService extends ChangeNotifier {
  List<Book> bookResults = [];

  // ignore: prefer_typing_uninitialized_variables
  var textController = TextEditingController();

  num startIndex = 0;

  BookService() {
    getBookResult();
  }

  void getBookResult({bool isNewSearch = false}) async {
    if (isNewSearch) {
      startIndex = 0;
      bookResults.clear();
    }

    try {
      Response result = await Dio().get(
          "https://www.googleapis.com/books/v1/volumes?q=${textController.text}&maxResults=10&startIndex=$startIndex");

      var items = result.data['items'];

      if (items != null) {
        for (var item in items) {
          var volumeInfo = item['volumeInfo'];
          if (volumeInfo != null) {
            var title = volumeInfo["title"];
            var imageLinks = volumeInfo["imageLinks"];
            var imageLinkThumbnail = imageLinks?["thumbnail"] ?? "noPhoto";
            var infoLink = volumeInfo["infoLink"];
            if (title == null ||
                imageLinkThumbnail == null ||
                infoLink == null) {
              continue;
            }
            Book bookInstance = Book(
                title: title,
                imageLink: imageLinkThumbnail,
                infoLink: infoLink);
            bookResults.add(bookInstance);
          }
        }
        startIndex += items.length;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }
}
