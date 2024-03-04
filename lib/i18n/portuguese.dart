import 'package:intl/intl.dart';

import 'app_localizations.dart';
import 'messages_all.dart';

class Portuguese extends AppLocalizations {
  Portuguese() {
    initializeMessages('pt');
  }
  @override
  String get title {
    return Intl.message(
      'Minha Biblioteca',
      name: 'title',
      desc: 'The application title',
    );
  }

  String get addBook {
    return Intl.message(
      'Adicionar Livro',
      name: 'addBook',
      desc: 'The button to add a book',
    );
  }

  String get myBooks {
    return Intl.message(
      'Meus Livros',
      name: 'myBooks',
      desc: 'The button to see the user\'s books',
    );
  }

  String get wishList {
    return Intl.message(
      'Lista de Desejos',
      name: 'wishList',
      desc: 'The button to see the user\'s wish list',
    );
  }

  String get loans {
    return Intl.message(
      'Empréstimos',
      name: 'loans',
      desc: 'The button to see the user\'s loans',
    );
  }

  String get contact {
    return Intl.message(
      'Fale Conosco',
      name: 'contact',
      desc: 'The button to contact the developer team',
    );
  }

  String get aboutApp {
    return Intl.message(
      'Sobre o App',
      name: 'aboutApp',
      desc: 'The button to see the app information',
    );
  }
}
