// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String? MessageIfAbsent(String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'en';

  @override
  final Map<String, dynamic> messages =
      _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
        'aboutApp': MessageLookupByLibrary.simpleMessage('About the App'),
        'addBook': MessageLookupByLibrary.simpleMessage('Add Book'),
        'contact': MessageLookupByLibrary.simpleMessage('Contact'),
        'loans': MessageLookupByLibrary.simpleMessage('Loans'),
        'myBooks': MessageLookupByLibrary.simpleMessage('My Books'),
        'title': MessageLookupByLibrary.simpleMessage('My Library'),
        'wishList': MessageLookupByLibrary.simpleMessage('Wish List'),
      };
}
