import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/DatabaseHelper.dart';
import '../../models/book_model.dart';
import 'book_details_page.dart';

class MyBooksPage extends StatefulWidget {
  const MyBooksPage({super.key});

  @override
  State<MyBooksPage> createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Meus Livros'),
        ),
        body: FutureBuilder<List<Book>>(
          future:
              Provider.of<DatabaseHelper>(context, listen: false).getBooks(),
          builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(snapshot.data![index].title),
                          subtitle: Text(snapshot.data![index].author),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailsPage(
                                    book: snapshot.data![index]),
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
                );
              }
            }
          },
        ));
  }
}
