// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(title) => "No Available ${title}s";

  static String m1(title) => "Which ${title}?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutUs": MessageLookupByLibrary.simpleMessage("About us"),
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "areYouSureToDelete": MessageLookupByLibrary.simpleMessage(
            "Do you want to delete the card and contact?"),
        "buyANfcBusinessCard":
            MessageLookupByLibrary.simpleMessage("Buy a NFC business card"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "company": MessageLookupByLibrary.simpleMessage("Company"),
        "contactDeleted":
            MessageLookupByLibrary.simpleMessage("Contact got deleted!"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "digitizeYourPaperBusinessCards": MessageLookupByLibrary.simpleMessage(
            "Digitize your paper business cards and add them automatically to your phone contacts. Get started and scan your first card."),
        "emailAddress": MessageLookupByLibrary.simpleMessage("Email Address"),
        "getADigitalBusinessCard":
            MessageLookupByLibrary.simpleMessage("Get a digital business card"),
        "loveItShareIt":
            MessageLookupByLibrary.simpleMessage("Love it? Share it!"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "noAvailable": MessageLookupByLibrary.simpleMessage("No Available"),
        "noAvailableTitles": m0,
        "openInContacts":
            MessageLookupByLibrary.simpleMessage("Open in contacts"),
        "orderForYourCompany":
            MessageLookupByLibrary.simpleMessage("Order for your company"),
        "phone": MessageLookupByLibrary.simpleMessage("Phone"),
        "placeCardInsideRectangle": MessageLookupByLibrary.simpleMessage(
            "Place the card within the frame"),
        "position": MessageLookupByLibrary.simpleMessage("Position"),
        "privacyTerms": MessageLookupByLibrary.simpleMessage("Privacy & Terms"),
        "readApiDocumentation":
            MessageLookupByLibrary.simpleMessage("Read API Documentation"),
        "scan": MessageLookupByLibrary.simpleMessage("Scan"),
        "scans": MessageLookupByLibrary.simpleMessage("Scans"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "website": MessageLookupByLibrary.simpleMessage("Website"),
        "welcomeToSpreadlyScan":
            MessageLookupByLibrary.simpleMessage("Welcome to Spreadly Scan!"),
        "whichTitle": m1
      };
}
