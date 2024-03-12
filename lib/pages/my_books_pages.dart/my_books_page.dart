import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_icons/awesome_icons.dart';
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
  bool _selectionMode = false; // novo estado para controlar o modo de seleção
  ValueNotifier<List<Book>> _selectedBooks = ValueNotifier<List<Book>>(
      []); // ValueNotifier para armazenar os livros selecionados

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
          leading: _selectionMode
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _selectionMode = false;
                      _selectedBooks.value.clear();
                    });
                  },
                )
              : null,
        ),
        floatingActionButton: _selectionMode
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: Color.fromARGB(255, 167, 77, 77),
                    onPressed: () async {
                      // Excluir os livros selecionados
                      await Provider.of<BookDbHelper>(context, listen: false)
                          .deleteBooks(_selectedBooks.value);
                      setState(() {
                        _selectionMode = false;
                        _selectedBooks.value.clear();
                      });
                    },
                    tooltip: "Excluir livros",
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Excluir",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    backgroundColor: const Color.fromARGB(255, 109, 149, 169),
                    onPressed: () {
                      setState(() {
                        _selectionMode = false;
                        _selectedBooks.value.clear();
                      });
                    },
                    tooltip: "Cancelar",
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: AutoSizeText(
                        "Cancelar",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 109, 149, 169),
                onPressed: () {
                  setState(() {
                    _selectionMode = true;
                  });
                },
                child: const Icon(
                  FontAwesomeIcons.trash,
                ),
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
                          return ValueListenableBuilder(
                            valueListenable: _selectedBooks,
                            builder: (context, List<Book> selectedBooks, _) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading:
                                        _selectionMode // se o modo de seleção estiver ativo, mostrar o checkbox
                                            ? Checkbox(
                                                value: selectedBooks
                                                    .contains(books[index]),
                                                onChanged: (selected) {
                                                  if (selected ?? false) {
                                                    selectedBooks
                                                        .add(books[index]);
                                                  } else {
                                                    selectedBooks
                                                        .remove(books[index]);
                                                  }
                                                  _selectedBooks.value =
                                                      List.from(selectedBooks);
                                                },
                                              )
                                            : null,
                                    title: Text(books[index].title),
                                    subtitle: Text(books[index].author),
                                    onTap: () {
                                      if (_selectionMode) {
                                        // se o modo de seleção estiver ativo, selecionar ou desmarcar o livro
                                        if (selectedBooks
                                            .contains(books[index])) {
                                          selectedBooks.remove(books[index]);
                                        } else {
                                          selectedBooks.add(books[index]);
                                        }
                                        _selectedBooks.value =
                                            List.from(selectedBooks);
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BookDetailsPage(
                                                    book: books[index]),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              );
                            },
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
    _selectedBooks.dispose();
    super.dispose();
  }
}
