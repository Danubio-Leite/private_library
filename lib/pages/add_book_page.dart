import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:private_library/components/custom_button.dart';
import 'package:provider/provider.dart';
import '../components/custom_textformfield.dart';
import 'package:http/http.dart' as http;

import '../helpers/DatabaseHelper.dart';
import '../models/book_model.dart';

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
  final publishedDateController = TextEditingController();
  final synopsisController = TextEditingController();
  final subtitleController = TextEditingController();
  final coverLinkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.barcode_reader),
          ),
        ],
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
                    icon: Icons.search,
                    onPressed: () async {
                      final details =
                          await fetchBookDetails(isbnController.text);
                      await fetchImageAndSave(isbnController.text);
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
                          publishedDateController.text =
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
                      controller: publishedDateController,
                      label: 'Ano de Publicação',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomFormField(
                label: 'Link da Capa',
                controller: coverLinkController,
              ),
              const SizedBox(height: 8),
              CustomFormField(
                controller: synopsisController,
                label: 'Sinopse',
                minLines: 1,
                maxLines: 5,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  texto: 'Salvar',
                  onPressed: () async {
                    String coverPath =
                        await fetchImageAndSave(isbnController.text);
                    final book = Book(
                      id: DateTime.now().millisecondsSinceEpoch,
                      isbn: isbnController.text,
                      title: titleController.text,
                      author: authorController.text,
                      publisher: publisherController.text,
                      genre: genreController.text,
                      publishedDate: publishedDateController.text,
                      synopsis: synopsisController.text,
                      subtitle: subtitleController.text,
                      cover: coverPath,
                    );
                    Provider.of<DatabaseHelper>(context, listen: false)
                        .saveBook(book);
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

  Future<String> fetchImageAndSave(String isbn) async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/customsearch/v1?key=AIzaSyBxvANHBwoEozEy-iq8DD1uiE7Gjv5fIA0&cx=62bc68a176da64dd5&searchType=image&q=isbn%209781461492986%20book%20cover'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        var firstItem = data['items'][0];
        if (firstItem['image'] != null &&
            firstItem['image']['thumbnailLink'] != null) {
          var thumbnailLink = firstItem['image']['thumbnailLink'];

          // Fazendo uma nova requisição para obter a imagem
          var responseImage = await http.get(Uri.parse(thumbnailLink));

          // Obtendo o diretório temporário
          final directory = await getTemporaryDirectory();

          // Criando o arquivo no diretório temporário
          final file = File('${directory.path}/thumbnail.jpg');

          // Escrevendo os bytes da imagem no arquivo
          await file.writeAsBytes(responseImage.bodyBytes);

          print('Imagem salva em ${file.path}');
          return file.path;
        } else {
          print('O primeiro item não contém um thumbnailLink.');
          throw Exception('Thumbnail link not found');
        }
      } else {
        print('Nenhum item encontrado na resposta da API.');
        throw Exception('No items found in API response');
      }
    } else {
      throw Exception('Failed to load image details');
    }
  }
}
