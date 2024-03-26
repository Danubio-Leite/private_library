import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../components/custom_button.dart';
import '../components/custom_textformfield.dart';
import '../helpers/preferences_db_helper.dart';
import '../models/preferences_model.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPage createState() => _ContactPage();
}

class _ContactPage extends State<ContactPage> {
  final snackBar =
      const SnackBar(content: Text('Recebemos sua sugestão. Obrigado!'));
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? phone;
  String? message;
  String? email;

  void _enviarSugestao() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: const Color.fromARGB(255, 0, 96, 164),
                    size: 60,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Enviando sugestão...",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 96, 164),
                    ),
                  ), // O texto
                ),
              ],
            ),
          );
        },
      );
      CollectionReference sugestoes =
          FirebaseFirestore.instance.collection('sugestoes');
      try {
        await sugestoes.doc('${name!} ${DateTime.now()}').set({
          'name': name,
          'phone': phone,
          'email': email,
          'message': message,
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      } catch (e) {
        Navigator.pop(context);
        const snackBarErro = SnackBar(
            content: Text(
                'Erro ao enviar sugestão. Verifique sua conexão com a internet.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBarErro);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Preferences>>(
        future: Provider.of<PreferencesDbHelper>(context, listen: false)
            .queryAllRows(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            Preferences preferences = snapshot.data!.first;

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Sugestões',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'Encontrou algum erro ou tem alguma sugestão de nova função? Nos envie!',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          label: 'Nome',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, insira seu name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            name = value;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          maskFormatter: MaskTextInputFormatter(
                            mask: '(##) #####-####',
                            filter: {"#": RegExp(r'[0-9]')},
                          ),
                          keyboardType: TextInputType.phone,
                          label: 'Whatsapp (Opcional)',
                          onSaved: (value) {
                            phone = value;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          label: 'Email',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, insira seu email';
                            }
                            if (!value.contains('@')) {
                              return 'Por favor, insira um email válido';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            email = value;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          minLines: 1,
                          maxLines: 5,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, insira sua sugestão';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            message = value;
                          },
                          label: 'Sugestão',
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomButton(
                            theme: preferences.theme,
                            texto: 'Enviar',
                            onPressed: () {
                              _enviarSugestao();
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
