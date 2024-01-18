import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scanner/modules/home/data/datasources/card_datasource.dart';
import 'package:scanner/modules/home/domain/models/dtos/scanned_card_dto.dart';

///[ContactsController] state Notifer class

class ContactsController extends StateNotifier<ContactsState> {
  ///[ContactsController] constructor

  ContactsController(
    this.ref,
  ) : super(ContactsInitial());

  ///StateNotifier ref gives access to app wide notifers

  final StateNotifierProviderRef<ContactsController, ContactsState> ref;

  ///List of user contacts
  // List<ScannedCardDto> contactsList = [];

  ///List of filtered contacts

  List<ScannedCardDto> displayContactsList = [];

  ///Find contacts base on attribtes
  List<ScannedCardDto> searchContacts(
    // List<ScannedCardDto> contactsList,
    String searchTerm,
  ) {
    final searchTerms = searchTerm.toLowerCase().split(' ');
    final contactsList = CardDataRepo.getCardsSync();

    final filteredContacts = contactsList.where((contact) {
      final concatenatedText = '${contact.firstName} '
          '${contact.lastName} '
          '${contact.company ?? ''} '
          '${contact.notes ?? ''} '
          '${contact.position ?? ''} ';
      final textToSearch = concatenatedText.toLowerCase();

      return searchTerms.every(textToSearch.contains);
    }).toList();

    print(filteredContacts.length);
    displayContactsList = filteredContacts;

    return filteredContacts;
  }
}

///Globally available Riverpod provider[contactsProvider] accessable using the
///ref object with a consumer widget
final contactsProvider =
    StateNotifierProvider<ContactsController, ContactsState>((ref) {
  return ContactsController(ref);
});

/// Abstract base class for different states related to user accounts.
abstract class ContactsState {}

/// Represents the initial state
class ContactsInitial extends ContactsState {}

/// Represents the loading state
class ContactsLoading extends ContactsState {}

/// Represents the success state
class ContactsSuccess extends ContactsState {}

/// Represents an error state with an error message
class ContactsError extends ContactsState {
  ///[message] represents the pretty error returned

  final String message;

  ///[ ContactsError] constructor returning error message to controller class
  ContactsError(this.message);
}
