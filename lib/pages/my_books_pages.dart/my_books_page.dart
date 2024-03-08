import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/book_db_helper.dart';
import '../../models/book_model.dart';
import 'book_details_page.dart';

class MyBooksPage extends StatefulWidget {
  const MyBooksPage({super.key});

  @override
  State<MyBooksPage> createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Meus Livros'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            FutureBuilder<List<Book>>(
              future:
                  Provider.of<BookDbHelper>(context, listen: false).getBooks(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else {
                    final books = snapshot.data!.where((book) {
                      return book.title
                              .toLowerCase()
                              .contains(_searchText.toLowerCase()) ||
                          book.author
                              .toLowerCase()
                              .contains(_searchText.toLowerCase());
                    }).toList();
                    return Expanded(
                      child: ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (_, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(books[index].title),
                                subtitle: Text(books[index].author),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BookDetailsPage(book: books[index]),
                                    ),
                                  );
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Divider(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
