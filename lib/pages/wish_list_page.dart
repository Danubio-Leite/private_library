import 'dart:io';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/wish_db_helper.dart';
import '../models/wish_model.dart';

class WishListPage extends StatelessWidget {
  const WishListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wish List'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 109, 149, 169),
        onPressed: () {
          showDialog(
              context: context, builder: (context) => AddWishDialog(context));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Consumer<WishDbHelper>(builder: (context, dbHelper, child) {
            return FutureBuilder<List<Wish>>(
              future: dbHelper.getWishes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final wishes = snapshot.data;
                    if (wishes!.isEmpty) {
                      return const Expanded(
                        child: Center(
                          child: Text('No wishes yet'),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: wishes.length,
                        itemBuilder: (context, index) {
                          final wish = wishes[index];
                          print(wish.author);
                          return Column(
                            children: [
                              ListTile(
                                title: Text(wish.title),
                                subtitle: wish.author != null
                                    ? Text('Author: ${wish.author}')
                                    : const Text('No author'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        FontAwesomeIcons.shoppingCart,
                                        size: 18,
                                      ),
                                      onPressed: () async {
                                        try {
                                          final url =
                                              'https://www.amazon.com.br/gp/search?ie=UTF8&tag=bluedot0d-20&linkCode=ur2&linkId=9722106adc58c66c61e16cfe81021d8b&camp=1789&creative=9325&index=books&keywords=${Uri.encodeFull(wish.title)}';
                                          if (await canLaunchUrl(
                                              Uri.parse(url))) {
                                            await launchUrl(Uri.parse(url));
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        } catch (e) {
                                          print('An error occurred: $e');
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 30,
                                      child: VerticalDivider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        FontAwesomeIcons.trash,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        dbHelper.deleteWish(wish.id);
                                      },
                                    ),
                                  ],
                                ),
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
                  return const Center(
                    child: Text('Error fetching wishes'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget AddWishDialog(context) {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    return AlertDialog(
      title: const Text('Add a wish'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: authorController,
            decoration: const InputDecoration(labelText: 'Author'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final dbHelper = Provider.of<WishDbHelper>(context, listen: false);
            dbHelper.saveWish(
              Wish(
                id: DateTime.now().millisecondsSinceEpoch,
                title: titleController.text,
                author: authorController.text,
              ),
            );

            Navigator.pop(context);
          },
          child: const Text('Add'),
        )
      ],
    );
  }
}
