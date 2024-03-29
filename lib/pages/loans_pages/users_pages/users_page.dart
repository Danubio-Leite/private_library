import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import '../../../helpers/user_db_helper.dart';
import '../../../models/user_model.dart';
import 'add_User_page.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({
    super.key,
  });

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

                      if (users.isEmpty) {
                        return const Expanded(
                          child: Center(
                            child: Text('Nenhum usuário cadastrado'),
                          ),
                        );
                      }

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
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      '',
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.close),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        users[index].name,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 24),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      if (users[index].phone !=
                                                          null)
                                                        Text(
                                                            'Whatsapp: ${users[index].phone ?? ''}'),
                                                      if (users[index].email !=
                                                          null)
                                                        Text(
                                                            'Email: ${users[index].email ?? ''}'),
                                                      const SizedBox(
                                                          height: 36),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(
                                          FontAwesomeIcons.edit,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          TextEditingController nameController =
                                              TextEditingController(
                                                  text: users[index].name);
                                          TextEditingController
                                              emailController =
                                              TextEditingController(
                                                  text: users[index].email);
                                          TextEditingController
                                              phoneController =
                                              TextEditingController(
                                            text: users[index].phone ?? '',
                                          );

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Editar usuário'),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            nameController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Nome',
                                                        ),
                                                      ),
                                                      TextFormField(
                                                        inputFormatters: [
                                                          MaskTextInputFormatter(
                                                            mask:
                                                                '(##) #####-####',
                                                            filter: {
                                                              "#": RegExp(
                                                                  r'[0-9]')
                                                            },
                                                          ),
                                                        ],
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        controller:
                                                            phoneController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Whatsapp',
                                                        ),
                                                      ),
                                                      TextField(
                                                        controller:
                                                            emailController,
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Email',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                                                            'Salvar'),
                                                        onPressed: () {
                                                          User updatedUser =
                                                              User(
                                                            id: users[index].id,
                                                            name: nameController
                                                                .text,
                                                            phone:
                                                                phoneController
                                                                    .text,
                                                            email:
                                                                emailController
                                                                    .text,
                                                          );
                                                          Provider.of<UserDbHelper>(
                                                                  context,
                                                                  listen: false)
                                                              .updateUser(
                                                                  updatedUser); // Método para atualizar o usuário
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
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                insetPadding:
                                                    const EdgeInsets.all(16),
                                                title: const Text(
                                                    'Confirmação de Exclusão'),
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
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      77,
                                                                      144,
                                                                      117),
                                                              content: Text(
                                                                  '${users[index].name} foi removido da lista de usuários.'),
                                                            ),
                                                          );
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
