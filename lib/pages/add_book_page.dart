// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:private_library/components/custom_button.dart';
import 'package:provider/provider.dart';
import '../components/custom_textformfield.dart';
import 'package:http/http.dart' as http;
import '../helpers/book_db_helper.dart';
import '../models/book_model.dart';
import 'dart:ui' as ui;

import '../routes/routes.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  String dropdownValue = 'Físico';
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _globalKey = GlobalKey();
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () async {
              String barcode = await FlutterBarcodeScanner.scanBarcode(
                "#ff6666",
                "Cancelar",
                true,
                ScanMode.BARCODE,
              );
              isbnController.text = barcode;

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text("Buscando detalhes do livro..."),
                      ],
                    ),
                  );
                },
              );

              try {
                final details = await fetchBookDetails(isbnController.text);
                await fetchImageAndSave(isbnController.text);
                if (details != null &&
                    details['items'] != null &&
                    details['items'].length > 0) {
                  var bookDetails = details['items'][0]['volumeInfo'];
                  if (bookDetails != null) {
                    titleController.text = bookDetails['title'] ?? '';
                    subtitleController.text = bookDetails['subtitle'] ?? '';
                    authorController.text = bookDetails['authors'] != null
                        ? bookDetails['authors'][0]
                        : '';
                    publisherController.text = bookDetails['publisher'] ?? '';
                    genreController.text = bookDetails['categories'] != null
                        ? bookDetails['categories'][0]
                        : '';
                    publishedDateController.text =
                        bookDetails['publishedDate'] != null
                            ? bookDetails['publishedDate'].substring(0, 4)
                            : '';
                    synopsisController.text = bookDetails['description'] ?? '';
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Informações do livro não encontradas.'),
                      ),
                    );
                  }
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Informações do livro não encontradas.'),
                  ),
                );
              } finally {
                Navigator.of(context).pop(); // Fecha o AlertDialog
              }
            },
            child: Image.asset(
              'assets/images/icons/barcode.png',
              height: double.infinity,
              fit: BoxFit.scaleDown,
            ),
          ),
        ],
        title: const Text('Adicionar Livro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Teste de navegação com o pushReplacementNamed
            Navigator.pushReplacementNamed(context, Routes.HOME);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: CustomFormField(
                        controller: isbnController,
                        label: 'ISBN',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      icon: Icons.search,
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 12),
                                  Text("Buscando detalhes do livro..."),
                                ],
                              ),
                            );
                          },
                        );

                        try {
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
                              authorController.text =
                                  bookDetails['authors'] != null
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
                                      ? bookDetails['publishedDate']
                                          .substring(0, 4)
                                      : '';
                              synopsisController.text =
                                  bookDetails['description'] ?? '';
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Informações do livro não encontradas.'),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Informações do livro não encontradas.'),
                            ),
                          );
                        } finally {
                          Navigator.of(context).pop(); // Fecha o AlertDialog
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomFormField(
                  controller: titleController,
                  label: 'Título',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório, insira o título da obra';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório, insira o nome do autor';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                CustomFormField(
                  controller: publisherController,
                  label: 'Editora',
                ),
                const SizedBox(height: 8),
                CustomFormField(
                  controller: genreController,
                  label: 'Gênero',
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>[
                          'Físico',
                          'Digital',
                          'Audiobook',
                          'Outro'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        borderRadius: BorderRadius.circular(5),
                        underline: const SizedBox(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: CustomFormField(
                        controller: publishedDateController,
                        label: 'Ano de Publicação',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ],
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
                      if (_formKey.currentState!.validate()) {
                        String coverPath =
                            await fetchImageAndSave(isbnController.text);

                        List<int> imageBytes =
                            await File(coverPath).readAsBytesSync();

                        // Codificando a lista de bytes em uma string base64
                        String base64Image = base64Encode(imageBytes);
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
                          cover: base64Image,
                          format: dropdownValue,
                        );
                        Provider.of<BookDbHelper>(context, listen: false)
                            .saveBook(book);
                        Navigator.pushReplacementNamed(context, Routes.HOME);
                      }
                    },
                  ),
                )
              ],
            ),
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
        'https://www.googleapis.com/customsearch/v1?key=AIzaSyBxvANHBwoEozEy-iq8DD1uiE7Gjv5fIA0&cx=62bc68a176da64dd5&searchType=image&q=isbn%20$isbn%20book%20cover'));

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
        return await coverPlaceholder(titleController.text);
      }
    } else {
      throw Exception('Failed to load image details');
    }
  }

  Future<String> coverPlaceholder(String bookTitle) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = Colors.white;
    final textPainter = TextPainter(
      text: TextSpan(
        text: bookTitle,
        style: const TextStyle(color: Colors.black, fontSize: 16.0),
      ),
      maxLines: 2,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: 120);

    canvas.drawRect(const Rect.fromLTWH(0, 0, 120, 180), paint);
    textPainter.paint(canvas,
        Offset((120 - textPainter.width) / 2, (180 - textPainter.height) / 2));

    final img = await recorder.endRecording().toImage(120, 180);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    if (data != null) {
      // Codificando os bytes da imagem em uma string base64
      String base64Image = base64Encode(data.buffer.asUint8List());
      return base64Image;
    } else {
      throw Exception('Failed to convert image to byte data');
    }
  }
}
