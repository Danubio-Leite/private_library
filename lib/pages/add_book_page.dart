import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:private_library/components/custom_button.dart';
import '../components/custom_textformfield.dart';
import 'package:http/http.dart' as http;

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final isbnController = TextEditingController();
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final publisherController = TextEditingController();
  final genreController = TextEditingController();
  final yearController = TextEditingController();
  final synopsisController = TextEditingController();
  final subtitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Livro'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: CustomFormField(
                      controller: isbnController,
                      label: 'ISBN',
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomButton(
                    icon: const Icon(
                      Icons.search,
                      size: 28,
                      color: Colors.black,
                    ),
                    texto: '',
                    onPressed: () async {
                      final details =
                          await fetchBookDetails(isbnController.text);
                      if (details != null &&
                          details['items'] != null &&
                          details['items'].length > 0) {
                        var bookDetails = details['items'][0]['volumeInfo'];
                        if (bookDetails != null) {
                          titleController.text = bookDetails['title'] ?? '';
                          subtitleController.text =
                              bookDetails['subtitle'] ?? '';
                          authorController.text = bookDetails['authors'] != null
                              ? bookDetails['authors'][0]
                              : '';
                          publisherController.text =
                              bookDetails['publisher'] ?? '';
                          genreController.text =
                              bookDetails['categories'] != null
                                  ? bookDetails['categories'][0]
                                  : '';
                          yearController.text =
                              bookDetails['publishedDate'] != null
                                  ? bookDetails['publishedDate'].substring(0, 4)
                                  : '';
                          synopsisController.text =
                              bookDetails['description'] ?? '';
                        } else {
                          // Trate o caso em que os detalhes do livro não estão disponíveis
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  CustomButton(
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 28,
                        color: Colors.black,
                      ),
                      texto: '',
                      onPressed: () {})
                ],
              ),
              const SizedBox(height: 8),
              CustomFormField(
                controller: titleController,
                label: 'Título',
              ),
              const SizedBox(height: 8),
              CustomFormField(
                controller: subtitleController,
                label: 'Subtítulo',
              ),
              const SizedBox(height: 8),
              CustomFormField(
                controller: authorController,
                label: 'Autor',
              ),
              const SizedBox(height: 8),
              CustomFormField(
                controller: publisherController,
                label: 'Editora',
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: CustomFormField(
                      controller: genreController,
                      label: 'Gênero',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: CustomFormField(
                      controller: yearController,
                      label: 'Ano de Publicação',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomFormField(
                controller: synopsisController,
                label: 'Sinopse',
                maxLines: 5,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  texto: 'Salvar',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchBookDetails(String isbn) async {
    final response = await http.get(
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load book details');
    }
  }
}
