                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return AlertDialog(
                              //       title: Text(reading.book.title),
                              //       content: Column(
                              //         mainAxisSize: MainAxisSize.min,
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //         children: [
                              //           Text(
                              //               'Início da leitura: ${DateFormat('dd/MM/yyyy').format(reading.startDateReading)}'),
                              //           const SizedBox(height: 10),
                              //           if (reading.endDateReading != null)
                              //             Text(
                              //               'Fim: ${DateFormat('dd/MM/yyyy').format(reading.endDateReading!)}',
                              //             ),
                              //           if (reading.readingNote != null)
                              //             Text('Nota: ${reading.readingNote}'),
                              //         ],
                              //       ),
                              //       actions: [
                              //         Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceEvenly,
                              //           children: [
                              //             TextButton(
                              //               onPressed: () {
                              //                 Navigator.pop(context);
                              //               },
                              //               child: const Text('Fechar'),
                              //             ),
                              //             if (reading.endDateReading == null)
                              //               TextButton(
                              //                 onPressed: () async {
                              //                   reading.endDateReading =
                              //                       DateTime.now();
                              //                   Provider.of<ReadingDbHelper>(
                              //                           context,
                              //                           listen: false)
                              //                       .updateReading(reading);
                              //                   setState(() {});
                              //                   Navigator.pop(context);
                              //                 },
                              //                 child: const Text('Finalizar'),
                              //               ),
                              //           ],
                              //         ),
                              //       ],
                              //     );
                              //   },
                              // );