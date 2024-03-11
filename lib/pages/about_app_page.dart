import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About the app'),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'O Meus Livros foi desenvolvido para ajudar nas gestão de pequenas bibliotecas e gestão de coleções de livros.\n\nOs dados são armazenados localmente, em caso de limpeza dos dados da aplicação, desinstalação do aplicativo ou formatação do aparelho, eles serão perdidos.\n\nOs links de compra disponibilizados são provenientes do programa de associados Amazon e qualquer compra realizada através deles é de responsabilidade da Amazon Servicos de Varejo Do Brasil LTDA.\n\nCaso tenha sugestões para novas ferramentas ou ajustes nas atuais, sinta-se à vontade para compartilhar conosco através do ícone "Fale Conosco" disponível na tela inicial.',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                text:
                                    'Os ícones utilizados neste aplicativo são provenientes de '),
                            TextSpan(
                              text: 'flaticon.com',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(
                                      Uri.parse('https://www.flaticon.com/'));
                                },
                            ),
                            const TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                                text: ''),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Obrigado por baixar nosso app, faça bom uso!',
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                      Padding(
                        padding: const EdgeInsets.only(top: 36.0),
                        child: Center(
                          child: Image.asset(
                            'assets/images/blue.png',
                            height: MediaQuery.of(context).size.height * 0.09,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
