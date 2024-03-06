import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/book_model.dart';

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
                Center(
                  child: Image.memory(
                    base64Decode(book.cover!),
                    height: 200,
                  ),
                ),
              Text(
                book.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (book.subtitle != null && book.subtitle!.isNotEmpty)
                Column(
                  children: [
                    Text(
                      book.subtitle!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              Text(
                book.author,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              if (book.publisher != null && book.publisher!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.publisher!,
                      style: const TextStyle(
                        fontSize: 18,
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
                        fontSize: 18,
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
                        fontSize: 18,
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
