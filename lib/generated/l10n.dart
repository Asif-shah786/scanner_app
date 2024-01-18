// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Scan`
  String get scan {
    return Intl.message(
      'Scan',
      name: 'scan',
      desc: '',
      args: [],
    );
  }

  /// `Place the card within the frame`
  String get placeCardInsideRectangle {
    return Intl.message(
      'Place the card within the frame',
      name: 'placeCardInsideRectangle',
      desc: '',
      args: [],
    );
  }

  /// `Position`
  String get position {
    return Intl.message(
      'Position',
      name: 'position',
      desc: '',
      args: [],
    );
  }

  /// `Company`
  String get company {
    return Intl.message(
      'Company',
      name: 'company',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Website`
  String get website {
    return Intl.message(
      'Website',
      name: 'website',
      desc: '',
      args: [],
    );
  }

  /// `No Available`
  String get noAvailable {
    return Intl.message(
      'No Available',
      name: 'noAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `No Available {title}s`
  String noAvailableTitles(Object title) {
    return Intl.message(
      'No Available ${title}s',
      name: 'noAvailableTitles',
      desc: '',
      args: [title],
    );
  }

  /// `Which {title}?`
  String whichTitle(Object title) {
    return Intl.message(
      'Which $title?',
      name: 'whichTitle',
      desc: '',
      args: [title],
    );
  }

  /// `Scans`
  String get scans {
    return Intl.message(
      'Scans',
      name: 'scans',
      desc: '',
      args: [],
    );
  }

  /// `Order for your company`
  String get orderForYourCompany {
    return Intl.message(
      'Order for your company',
      name: 'orderForYourCompany',
      desc: '',
      args: [],
    );
  }

  /// `Love it? Share it!`
  String get loveItShareIt {
    return Intl.message(
      'Love it? Share it!',
      name: 'loveItShareIt',
      desc: '',
      args: [],
    );
  }

  /// `Get a digital business card`
  String get getADigitalBusinessCard {
    return Intl.message(
      'Get a digital business card',
      name: 'getADigitalBusinessCard',
      desc: '',
      args: [],
    );
  }

  /// `Buy a NFC business card`
  String get buyANfcBusinessCard {
    return Intl.message(
      'Buy a NFC business card',
      name: 'buyANfcBusinessCard',
      desc: '',
      args: [],
    );
  }

  /// `Privacy & Terms`
  String get privacyTerms {
    return Intl.message(
      'Privacy & Terms',
      name: 'privacyTerms',
      desc: '',
      args: [],
    );
  }

  /// `About us`
  String get aboutUs {
    return Intl.message(
      'About us',
      name: 'aboutUs',
      desc: '',
      args: [],
    );
  }

  /// `Digitize your paper business cards and add them automatically to your phone contacts. Get started and scan your first card.`
  String get digitizeYourPaperBusinessCards {
    return Intl.message(
      'Digitize your paper business cards and add them automatically to your phone contacts. Get started and scan your first card.',
      name: 'digitizeYourPaperBusinessCards',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Spreadly Scan!`
  String get welcomeToSpreadlyScan {
    return Intl.message(
      'Welcome to Spreadly Scan!',
      name: 'welcomeToSpreadlyScan',
      desc: '',
      args: [],
    );
  }

  /// `Read API Documentation`
  String get readApiDocumentation {
    return Intl.message(
      'Read API Documentation',
      name: 'readApiDocumentation',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete the card and contact?`
  String get areYouSureToDelete {
    return Intl.message(
      'Do you want to delete the card and contact?',
      name: 'areYouSureToDelete',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Open in contacts`
  String get openInContacts {
    return Intl.message(
      'Open in contacts',
      name: 'openInContacts',
      desc: '',
      args: [],
    );
  }

  /// `Contact got deleted!`
  String get contactDeleted {
    return Intl.message(
      'Contact got deleted!',
      name: 'contactDeleted',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
