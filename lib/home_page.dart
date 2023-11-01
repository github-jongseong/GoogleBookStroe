import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'book_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        context.read<BookService>().getBookResult();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookService>(
      builder: (context, bookService, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Google 북스토어",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: bookService.textController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          bookService.getBookResult(isNewSearch: true);
                        },
                        icon: Icon(Icons.search, color: Colors.black),
                      ),
                    ),
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) async {
                      bookService.getBookResult(isNewSearch: true);
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: bookService.bookResults.length,
                    itemBuilder: (context, index) {
                      var imageLink = bookService.bookResults[index].imageLink;

                      Widget leadingImage;

                      if (imageLink == "noPhoto") {
                        leadingImage = Image.asset(
                          "assets/noPhoto.jpg",
                          width: MediaQuery.of(context).size.width * 0.13,
                          height: MediaQuery.of(context).size.height * 0.5,
                          fit: BoxFit.cover,
                        );
                      } else {
                        leadingImage = Image.network(
                          imageLink,
                          width: MediaQuery.of(context).size.width * 0.13,
                          height: MediaQuery.of(context).size.height * 0.5,
                          fit: BoxFit.cover,
                        );
                      }

                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              bookService.bookResults[index].title,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            leading: ClipRect(
                              child: Align(
                                alignment: Alignment.center,
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: leadingImage,
                              ),
                            ),
                            onTap: () {
                              launchUrl(
                                Uri.parse(
                                    bookService.bookResults[index].infoLink),
                              );
                              debugPrint(
                                  bookService.bookResults[index].infoLink);
                            },
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                        ], // Column children
                      );
                    },
                  ),
                ),
              ], // Column children
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
