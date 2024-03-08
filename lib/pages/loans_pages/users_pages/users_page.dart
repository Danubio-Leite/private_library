import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/user_db_helper.dart';
import '../../../models/user_model.dart';
import 'add_User_page.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
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
          title: const Text('Usuários'),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 109, 149, 169),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddUserPage(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextField(
            //     controller: _searchController,
            //     decoration: const InputDecoration(
            //       labelText: 'Pesquisar',
            //       suffixIcon: Icon(Icons.search),
            //     ),
            //   ),
            // ),
            Consumer<UserDbHelper>(builder: (context, dbHelper, child) {
              return FutureBuilder<List<User>>(
                future: Provider.of<UserDbHelper>(context, listen: false)
                    .getUsers(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else {
                      final users = snapshot.data!.where((user) {
                        return user.name
                                .toLowerCase()
                                .contains(_searchText.toLowerCase()) ||
                            (user.email ?? '')
                                .toLowerCase()
                                .contains(_searchText.toLowerCase());
                      }).toList();
                      return Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (_, index) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(users[index].name),
                                  subtitle: Text(users[index].email ?? ''),
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => EditUserPage(
                                    //         user: users[
                                    //             index]), // Página para editar o usuário
                                    //   ),
                                    // );
                                  },
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => EditUserPage(
                                          //         user: users[
                                          //             index]), // Página para editar o usuário
                                          //   ),
                                          // );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                insetPadding:
                                                    const EdgeInsets.all(16),
                                                title: const Text(''),
                                                content: const Text(
                                                    'Você tem certeza que deseja excluir este usuário?'),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          elevation: 0,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                        ),
                                                        child: const Text(
                                                            'Cancelar'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          elevation: 0,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                        ),
                                                        child: const Text(
                                                            'Excluir'),
                                                        onPressed: () {
                                                          Provider.of<UserDbHelper>(
                                                                  context,
                                                                  listen: false)
                                                              .deleteUser(
                                                                  users[index]);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
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
                        ),
                      );
                    }
                  }
                },
              );
            }),
          ],
        ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
