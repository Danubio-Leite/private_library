// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:private_library/components/custom_button.dart';
import 'package:provider/provider.dart';

import '../../components/custom_dialog.dart';
import '../../helpers/loan_db_helper.dart';
import '../../helpers/reading_db_helper.dart';
import '../../helpers/user_db_helper.dart';
import '../../models/book_model.dart';
import '../../models/loan_model.dart';
import '../../models/reading_model.dart';
import '../../models/user_model.dart';
import '../loans_pages/users_pages/add_user_page.dart';

class BookDetailsPage extends StatelessWidget {
  final Book book;
  const BookDetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Livro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (book.cover != null && book.cover!.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 5,
                              child: AutoSizeText(
                                book.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                            if (book.subtitle != null &&
                                book.subtitle!.isNotEmpty)
                              Flexible(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: AutoSizeText(
                                    book.subtitle!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            Flexible(
                              child: AutoSizeText(
                                book.author,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.0),
                        child: Image.memory(
                          base64Decode(book.cover!),
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              if (book.publisher != null && book.publisher!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.publisher!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              if (book.publishedDate != null && book.publishedDate!.isNotEmpty)
                Column(
                  children: [
                    Text(
                      'Publicado em: ${book.publishedDate!}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              if (book.synopsis != null && book.synopsis!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.synopsis!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () async {
                        final users = await Provider.of<UserDbHelper>(context,
                                listen: false)
                            .getUsers();
                        if (users.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Nenhum usuário cadastrado'),
                                content: const Text(
                                    'Por favor, cadastre um usuário antes de emprestar um livro.'),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Cadastrar'),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return const AddUserPage(
                                                twoPop: true,
                                              );
                                            },
                                          ));
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          final loans = await Provider.of<LoanDbHelper>(context,
                                  listen: false)
                              .getLoans();
                          final readings = await Provider.of<ReadingDbHelper>(
                                  context,
                                  listen: false)
                              .getReadings();
                          if (loans.any((loan) =>
                              loan.book.id == book.id &&
                              loan.endDateLoan == null)) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Livro já emprestado'),
                                  content: const Text(
                                      'Este livro já está emprestado. Por favor, escolha outro livro ou verifique o status do empréstimo.'),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (readings.any((reading) =>
                              reading.book.id == book.id &&
                              reading.endDateReading == null)) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Leitura em andamento'),
                                    content: const Text(
                                        'Você está lendo este livro. Deseja registrar o término da leitura?'),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Não'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              final reading = readings
                                                  .firstWhere((reading) =>
                                                      reading.book.id ==
                                                          book.id &&
                                                      reading.endDateReading ==
                                                          null);
                                              reading.endDateReading =
                                                  DateTime.now();
                                              Provider.of<ReadingDbHelper>(
                                                      context,
                                                      listen: false)
                                                  .updateReading(reading);
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 77, 144, 117),
                                                  content: Text(
                                                      'Registrado o término da leitura de ${book.title}.'),
                                                ),
                                              );
                                            },
                                            child: const Text('Sim'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            customDialogBox(
                                context,
                                'Escolha um usuário para emprestar o livro:',
                                book,
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: FutureBuilder<List<User>>(
                                    future: Provider.of<UserDbHelper>(context,
                                            listen: false)
                                        .getUsers(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<User>> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Erro: ${snapshot.error}'));
                                        } else {
                                          final users = snapshot.data!;
                                          return Scrollbar(
                                            thickness: 4.0,
                                            radius: const Radius.circular(5.0),
                                            child: ListView.builder(
                                              itemCount: users.length,
                                              shrinkWrap: true,
                                              itemBuilder: (_, index) {
                                                return Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: ListTile(
                                                    title:
                                                        Text(users[index].name),
                                                    onTap: () {
                                                      customDialogBox(
                                                          context,
                                                          'Confirmação de Empréstimo',
                                                          book,
                                                          Text(
                                                              'Deseja emprestar o livro para ${users[index].name}?'),
                                                          [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Não'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    final loan =
                                                                        Loan(
                                                                      id: DateTime
                                                                              .now()
                                                                          .millisecondsSinceEpoch,
                                                                      user: users[
                                                                          index],
                                                                      book:
                                                                          book,
                                                                      startDateLoan:
                                                                          DateTime
                                                                              .now(),
                                                                    );
                                                                    Provider.of<LoanDbHelper>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .saveLoan(
                                                                            loan);
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        backgroundColor: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            77,
                                                                            144,
                                                                            117),
                                                                        content:
                                                                            Text('Livro Emprestado para ${users[index].name}.'),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Sim'),
                                                                ),
                                                              ],
                                                            ),
                                                          ]);
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                                [
                                  SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return const AddUserPage(
                                                    twoPop: true,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: const Text('Cadastrar Novo'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                          }
                        }
                      },
                      texto: 'Emprestar',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      onPressed: () async {
                        final users = await Provider.of<UserDbHelper>(context,
                                listen: false)
                            .getUsers();

                        final loans = await Provider.of<LoanDbHelper>(context,
                                listen: false)
                            .getLoans();

                        final readings = await Provider.of<ReadingDbHelper>(
                                context,
                                listen: false)
                            .getReadings();
                        if (loans.any((loan) =>
                            loan.book.id == book.id &&
                            loan.endDateLoan == null)) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Livro emprestado'),
                                content: const Text(
                                    'Este livro está emprestado. Registre a devolução antes de iniciar a leitura.'),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (readings.any((reading) =>
                            reading.book.id == book.id &&
                            reading.endDateReading == null)) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Leitura em andamento'),
                                  content: const Text(
                                      'Você já está lendo este livro. Deseja registrar o término da leitura?'),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Não'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            final reading = readings.firstWhere(
                                                (reading) =>
                                                    reading.book.id ==
                                                        book.id &&
                                                    reading.endDateReading ==
                                                        null);
                                            reading.endDateReading =
                                                DateTime.now();
                                            Provider.of<ReadingDbHelper>(
                                                    context,
                                                    listen: false)
                                                .updateReading(reading);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 77, 144, 117),
                                                content: Text(
                                                    'Registrado o término da leitura de ${book.title}.'),
                                              ),
                                            );
                                          },
                                          child: const Text('Sim'),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Deseja iniciar a leitura?',
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Não'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            final reading = Reading(
                                              id: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              book: book,
                                              startDateReading: DateTime.now(),
                                            );
                                            Provider.of<ReadingDbHelper>(
                                                    context,
                                                    listen: false)
                                                .saveReading(reading);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 77, 144, 117),
                                                content: Text(
                                                    'Registrado o início da leitura de ${book.title}.'),
                                              ),
                                            );
                                          },
                                          child: const Text('Sim'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                      texto: 'Iniciar Leitura',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
