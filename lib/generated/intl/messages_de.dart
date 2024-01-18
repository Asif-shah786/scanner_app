// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static String m0(title) => "${title} nicht gefunden";

  static String m1(title) => "${title} wählen";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutUs": MessageLookupByLibrary.simpleMessage("Über uns"),
        "address": MessageLookupByLibrary.simpleMessage("Adresse"),
        "areYouSureToDelete": MessageLookupByLibrary.simpleMessage(
            "Willst du die Karte und den Kontakt löschen?"),
        "buyANfcBusinessCard":
            MessageLookupByLibrary.simpleMessage("NFC-Visitenkarten kaufen"),
        "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
        "company": MessageLookupByLibrary.simpleMessage("Firma"),
        "contactDeleted":
            MessageLookupByLibrary.simpleMessage("Kontakt wurde gelöscht!"),
        "delete": MessageLookupByLibrary.simpleMessage("Löschen"),
        "digitizeYourPaperBusinessCards": MessageLookupByLibrary.simpleMessage(
            "Digitalisiere deine Visitenkarten und speicher sie automatisch in deinen Kontakten"),
        "emailAddress": MessageLookupByLibrary.simpleMessage("E-Mail Adresse"),
        "getADigitalBusinessCard": MessageLookupByLibrary.simpleMessage(
            "Digitale Visitenkarte erstellen"),
        "loveItShareIt": MessageLookupByLibrary.simpleMessage(
            "Spreadly Scan weiterempfehlen"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "noAvailable": MessageLookupByLibrary.simpleMessage("Nicht verfügbar"),
        "noAvailableTitles": m0,
        "openInContacts":
            MessageLookupByLibrary.simpleMessage("In Konakte öffnen"),
        "orderForYourCompany":
            MessageLookupByLibrary.simpleMessage("Als Firma bestellen"),
        "phone": MessageLookupByLibrary.simpleMessage("Telefon"),
        "placeCardInsideRectangle": MessageLookupByLibrary.simpleMessage(
            "Halte die Karte in dem Rahmen"),
        "position": MessageLookupByLibrary.simpleMessage("Job"),
        "privacyTerms":
            MessageLookupByLibrary.simpleMessage("Datenschutz & AGB"),
        "readApiDocumentation":
            MessageLookupByLibrary.simpleMessage("API-Dokumentation lesen"),
        "scan": MessageLookupByLibrary.simpleMessage("Scannen"),
        "scans": MessageLookupByLibrary.simpleMessage("Scans"),
        "search": MessageLookupByLibrary.simpleMessage("Suchen"),
        "website": MessageLookupByLibrary.simpleMessage("Webseite"),
        "welcomeToSpreadlyScan": MessageLookupByLibrary.simpleMessage(
            "Willkommen bei Spreadly Scan!"),
        "whichTitle": m1
      };
}
