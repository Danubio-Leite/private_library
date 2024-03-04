import 'package:intl/intl.dart';

import 'app_localizations.dart';
import 'messages_all.dart';

class English extends AppLocalizations {
  English() {
    initializeMessages('en');
  }
  @override
  String get title {
    return Intl.message(
      'My Library',
      name: 'title',
      desc: 'The application title',
    );
  }

  String get addBook {
    return Intl.message(
      'Add Book',
      name: 'addBook',
      desc: 'The button to add a book',
    );
  }

  String get myBooks {
    return Intl.message(
      'My Books',
      name: 'myBooks',
      desc: 'The button to see the user\'s books',
    );
  }

  String get wishList {
    return Intl.message(
      'Wish List',
      name: 'wishList',
      desc: 'The button to see the user\'s wish list',
    );
  }

  String get loans {
    return Intl.message(
      'Loans',
      name: 'loans',
      desc: 'The button to see the user\'s loans',
    );
  }

  String get contact {
    return Intl.message(
      'Contact',
      name: 'contact',
      desc: 'The button to contact the developer team',
    );
  }

  String get aboutApp {
    return Intl.message(
      'About the App',
      name: 'aboutApp',
      desc: 'The button to see the app information',
    );
  }
}

// class EnglishAddBook {
//   String get addBookPageTitle {
//     return Intl.message(
//       'Add Book',
//       name: 'addBookPageTitle',
//       desc: 'The title of the add book page',
//     );
//   }

//   String get addBookPageButton {
//     return Intl.message(
//       'Add',
//       name: 'addBookPageButton',
//       desc: 'The button to add a book',
//     );
//   }

//   String get addBookPageName {
//     return Intl.message(
//       'Name',
//       name: 'addBookPageName',
//       desc: 'The label for the book name field',
//     );
//   }

//   String get addBookPageAuthor {
//     return Intl.message(
//       'Author',
//       name: 'addBookPageAuthor',
//       desc: 'The label for the book author field',
//     );
//   }

//   String get addBookPageGenre {
//     return Intl.message(
//       'Genre',
//       name: 'addBookPageGenre',
//       desc: 'The label for the book genre field',
//     );
//   }

//   String get addBookPageYear {
//     return Intl.message(
//       'Year',
//       name: 'addBookPageYear',
//       desc: 'The label for the book year field',
//     );
//   }

//   String get addBookPagePages {
//     return Intl.message(
//       'Pages',
//       name: 'addBookPagePages',
//       desc: 'The label for the book pages field',
//     );
//   }

//   String get addBookPagePublisher {
//     return Intl.message(
//       'Publisher',
//       name: 'addBookPagePublisher',
//       desc: 'The label for the book publisher field',
//     );
//   }

//   String get addBookPageLanguage {
//     return Intl.message(
//       'Language',
//       name: 'addBookPageLanguage',
//       desc: 'The label for the book language field',
//     );
//   }

//   String get addBookPageDescription {
//     return Intl.message(
//       'Description',
//       name: 'addBookPageDescription',
//       desc: 'The label for the book description field',
//     );
//   }

//   String get addBookPageImage {
//     return Intl.message(
//       'Image',
//       name: 'addBookPageImage',
//       desc: 'The label for the book image field',
//     );
//   }
// }

// class EnglishMyBooks {
//   String get myBooksPageTitle {
//     return Intl.message(
//       'My Books',
//       name: 'myBooksPageTitle',
//       desc: 'The title of the my books page',
//     );
//   }

//   String get myBooksPageSearch {
//     return Intl.message(
//       'Search',
//       name: 'myBooksPageSearch',
//       desc: 'The label for the search field',
//     );
//   }

//   String get myBooksPageFilter {
//     return Intl.message(
//       'Filter',
//       name: 'myBooksPageFilter',
//       desc: 'The label for the filter field',
//     );
//   }

//   String get myBooksPageFilterAll {
//     return Intl.message(
//       'All',
//       name: 'myBooksPageFilterAll',
//       desc: 'The label for the filter all option',
//     );
//   }

//   String get myBooksPageFilterRead {
//     return Intl.message(
//       'Read',
//       name: 'myBooksPageFilterRead',
//       desc: 'The label for the filter read option',
//     );
//   }

//   String get myBooksPageFilterReading {
//     return Intl.message(
//       'Reading',
//       name: 'myBooksPageFilterReading',
//       desc: 'The label for the filter reading option',
//     );
//   }

//   String get myBooksPageFilterWish {
//     return Intl.message(
//       'Wish',
//       name: 'myBooksPageFilterWish',
//       desc: 'The label for the filter wish option',
//     );
//   }

//   String get myBooksPageFilterNotRead {
//     return Intl.message(
//       'Not Read',
//       name: 'myBooksPageFilterNotRead',
//       desc: 'The label for the filter not read option',
//     );
//   }
// }
