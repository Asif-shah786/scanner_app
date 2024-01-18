import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner/modules/home/domain/models/dtos/scanned_card_dto.dart';

///
class CardDataRepo {
  static late Isar _isar;

  ///isar instance
  static Isar get isarDb => _isar;

  ///Function to initIsar

  Future<void> initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ScannedCardDtoSchema],
      directory: dir.path,
    );
  }

  ///Function to addToDB
  static Future<int?> addToDB(ScannedCardDto data) async {
    int? id;
    await _isar.writeTxn(() async {
      id = await _isar.scannedCardDtos.put(data);
    });

    return id;
  }

  ///Function to getCards

  static Future<List<ScannedCardDto>> getCards() async {
    var scannedCards = <ScannedCardDto>[];
    await _isar.txn(() async {
      scannedCards = await _isar.scannedCardDtos.where().findAll();
    });

    return scannedCards.reversed.toList();
  }

  ///Function to updateContact
  static Future<ScannedCardDto?> updateContact(Contact contact) async {
    ScannedCardDto? scannedCards;
    await _isar.writeTxn(() async {
      scannedCards = await _isar.scannedCardDtos
          .filter()
          .deviceIdEqualTo(contact.id)
          .findFirst()

        // final newContact = ScannedCardDto()
        ?..firstName = contact.name.first
        ..lastName = contact.name.last
        ..notes = contact.notes.first.note
        ..address = [...contact.addresses.map((address) => address.address)]
        ..emails = [...contact.emails.map((email) => email.address)]
        ..websites = [...contact.websites.map((website) => website.url)]
        ..phones = [...contact.phones.map((phone) => (phone.number))]
        ..company = contact.organizations.firstOrNull?.company ?? ''
        ..position = contact.organizations.firstOrNull?.title ?? '';

      if (scannedCards != null) {
        await _isar.scannedCardDtos.put(scannedCards!);
      }
    });

    return scannedCards;
  }

  ///Function to getCard
  static ScannedCardDto? getCard(int id) {
    final scannedCards = _isar.scannedCardDtos.getSync(id);
    return scannedCards;
  }

  ///Function to getCardsSync
  static List<ScannedCardDto> getCardsSync() {
    var scannedCards = <ScannedCardDto>[];
    _isar.txnSync(() {
      scannedCards = _isar.scannedCardDtos.where().findAllSync();
    });

    return scannedCards.reversed.toList();
  }

  static Future<bool> deleteCard(int id) async {
    return await _isar.writeTxn(() async {
      return await _isar.scannedCardDtos.delete(id);
    });
  }

}
