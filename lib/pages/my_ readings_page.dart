import 'dart:math';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:private_library/components/custom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:awesome_icons/awesome_icons.dart';

import '../helpers/reading_db_helper.dart';
import '../models/reading_model.dart';

class MyReadingsPage extends StatefulWidget {
  const MyReadingsPage({Key? key}) : super(key: key);

  @override
  State<MyReadingsPage> createState() => _MyReadingsPageState();
}

class _MyReadingsPageState extends State<MyReadingsPage> {
  bool showFinishedReadings = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Readings'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text(
                      'Em andamento',
                      style: TextStyle(
                        color: showFinishedReadings
                            ? Colors.black
                            : Colors.blueGrey,
                        fontWeight: !showFinishedReadings
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showFinishedReadings = false;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                    child: VerticalDivider(
                      thickness: 1,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Finalizadas',
                      style: TextStyle(
                        color: !showFinishedReadings
                            ? Colors.black
                            : Colors.blueGrey,
                        fontWeight: showFinishedReadings
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showFinishedReadings = true;
                      });
                    },
                  ),
                ],
              ),
              const Divider(
                height: 1,
                thickness: 1,
              )
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Reading>>(
              future: Provider.of<ReadingDbHelper>(context).getReadings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  final readingBooks = snapshot.data;
                  if (readingBooks!.isEmpty) {
                    return const Center(
                      child: Text('No readings found.'),
                    );
                  }
                  final filteredReadings = readingBooks.where((reading) {
                    return showFinishedReadings
                        ? reading.endDateReading != null
                        : reading.endDateReading == null;
                  }).toList();

                  if (filteredReadings.isEmpty) {
                    return Center(
                      child: Text(showFinishedReadings
                          ? 'Nenhuma leitura finalizada.'
                          : 'Nenhuma leitura em andamento.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredReadings.length,
                    itemBuilder: (context, index) {
                      final reading = filteredReadings[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(reading.book.title),
                            subtitle: Text(reading.book.author),
                            onTap: () {
                              customDialogBox(
                                  context,
                                  reading.book.title,
                                  reading.book,
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Início da leitura: ${DateFormat('dd/MM/yyyy').format(reading.startDateReading)}'),
                                      const SizedBox(height: 10),
                                      if (reading.endDateReading != null)
                                        Text(
                                          'Fim: ${DateFormat('dd/MM/yyyy').format(reading.endDateReading!)}',
                                        ),
                                      if (reading.readingNote != null)
                                        Text('Nota: ${reading.readingNote}'),
                                    ],
                                  ),
                                  [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Fechar'),
                                        ),
                                        if (reading.endDateReading == null)
                                          TextButton(
                                            onPressed: () async {
                                              reading.endDateReading =
                                                  DateTime.now();
                                              Provider.of<ReadingDbHelper>(
                                                      context,
                                                      listen: false)
                                                  .updateReading(reading);
                                              setState(() {});
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Finalizar'),
                                          ),
                                      ],
                                    ),
                                  ]);
                            },
                            trailing: IconButton(
                              icon: Icon(
                                reading.endDateReading == null
                                    ? FontAwesomeIcons.bookOpen
                                    : FontAwesomeIcons.book,
                                color: reading.endDateReading == null
                                    ? Colors.blueGrey
                                    : Colors.blueGrey,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(reading.book.title),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Início da leitura: ${DateFormat('dd/MM/yyyy').format(reading.startDateReading)}'),
                                          const SizedBox(height: 10),
                                          if (reading.endDateReading != null)
                                            Text(
                                              'Fim: ${DateFormat('dd/MM/yyyy').format(reading.endDateReading!)}',
                                            ),
                                          if (reading.readingNote != null)
                                            Text(
                                                'Nota: ${reading.readingNote}'),
                                        ],
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Fechar'),
                                            ),
                                            if (reading.endDateReading == null)
                                              TextButton(
                                                onPressed: () {
                                                  customDialogBox(
                                                    context,
                                                    'Confirma o fim da leitura?',
                                                    reading.book,
                                                    const Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            'Deseja realmente finalizar a leitura?'),
                                                      ],
                                                    ),
                                                    [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancelar'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          reading.endDateReading =
                                                              DateTime.now();
                                                          Provider.of<ReadingDbHelper>(
                                                                  context,
                                                                  listen: false)
                                                              .updateReading(
                                                                  reading);
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Finalizar'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                                child: const Text('Finalizar'),
                                              ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                        ],
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
