import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/reading_db_helper.dart';
import '../models/reading_model.dart';

class MyReadingsPage extends StatelessWidget {
  const MyReadingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Readings'),
      ),
      body: Consumer<ReadingDbHelper>(builder: (context, dbHelper, child) {
        return FutureBuilder<List<Reading>>(
          future: dbHelper.getReadings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final readings = snapshot.data;
                if (readings!.isEmpty) {
                  return const Center(
                    child: Text('No readings yet'),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: readings.length,
                    itemBuilder: (context, index) {
                      final reading = readings[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(reading.book.title),
                            subtitle: reading.book.author != null
                                ? Text('Author: ${reading.book.author}')
                                : const Text('No author'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                dbHelper.deleteReading(reading.id!);
                              },
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      }),
    );
  }
}
