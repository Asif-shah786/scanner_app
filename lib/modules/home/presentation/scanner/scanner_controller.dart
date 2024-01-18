import 'dart:io';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scanner/modules/home/data/datasources/card_datasource.dart';
import 'package:scanner/modules/home/domain/models/dtos/scanned_card_dto.dart';
import 'package:scanner/modules/home/domain/services/device_contacts_imp_service.dart';
import 'package:scanner/modules/home/domain/services/service_service.dart';
import 'package:scanner/services/image/image_saver.dart';

///[ScannerController] state Notifer class

class ScannerController extends StateNotifier<ScannerState> {
  ///[ScannerController] constructor

  ScannerController(this.ref, this._serviceService) : super(ScannerInitial());

  ///StateNotifier ref gives access to app wide notifers

  final StateNotifierProviderRef<ScannerController, ScannerState> ref;

  final ServiceService _serviceService;

  // /// [caller] function call api and update state
  // Future<File?> saveImage(File imageFile) async {
  //   try {
  //     return await saveCapturedImage(imageFile);
  //   } on Exception catch (_) {
  //     return null;
  //   }
  // }

  /// [scanCard] function call api and update state
  Future<String?> scanCard(File imageFile, {bool shouldCrop = true}) async {
    try {
      state = ScannerLoading();

      final image = await saveCapturedImage(imageFile, crop: shouldCrop);

      final response = await _serviceService.scanCard(
        image,
        'business_card:${DateTime.timestamp()}',
      );

      ///Scan date
      final date = DateTime.now().toString().substring(0, 10);

      final scanned = ScannedCardDto()
        ..apiId = response.id
        ..emails =
            response.emails?.map((email) => email.toString()).toList() ?? []
        ..phones =
            response.phones?.map((phones) => phones.toString()).toList() ?? []
        ..websites = response.websites
                ?.map((websites) => websites.toString())
                .toList() ??
            []
        ..address =
            response.addresses?.map((address) => address.toString()).toList() ??
                []
        ..imagePath = image.path.split('/').last
        ..company = response.company
        ..department = response.department
        ..firstName = response.firstName ?? 'N/A'
        ..lastName = response.lastName ?? 'N/A'
        ..notes = 'Scanned by Spreadly Scan at $date'
        ..position = response.position;

      final newContact = Contact()
        ..name.first = response.firstName ?? ''
        ..name.last = response.lastName ?? ''
        ..notes = [
          Note(
            'Scanned by Spreadly Scan at $date',
          ),
        ]
        ..addresses = [
          ...response.addresses
                  ?.map((addresses) => Address(addresses.toString()))
                  .toList() ??
              [],
        ]
        ..emails = [
          ...response.emails
                  ?.map((email) => Email(email.toString()))
                  .toList() ??
              [],
        ]
        ..websites = [
          ...response.websites
                  ?.map((website) => Website(website.toString()))
                  .toList() ??
              [],
        ]
        ..phones = [
          ...response.phones
                  ?.map((phone) => Phone(phone.toString()))
                  .toList() ??
              [],
        ]
        ..organizations = [
          Organization(
            company: response.company ?? '',
            title: response.position ?? '',
          ),
        ];

      final deviceContact =
          await DeviceContactsImpService.addContact(newContact);

      ///Add device contact id
      scanned.deviceId = deviceContact?.id;

      final id = await CardDataRepo.addToDB(scanned);

      await CardDataRepo.getCards();

      state = ScannerSuccess();

      return id.toString();
    } on Exception catch (e) {
      state = ScannerError(e.toString());
      return null;
    }
  }
}

///Globally available Riverpod provider[scannerProvider] accessable using the
///ref object with a consumer widget
final scannerProvider =
    StateNotifierProvider<ScannerController, ScannerState>((ref) {
  return ScannerController(ref, ref.read(cardServiceProvider));
});

/// Abstract base class for different states related to user accounts.

abstract class ScannerState {}

/// Represents the initial state

class ScannerInitial extends ScannerState {}

/// Represents the loading state

class ScannerLoading extends ScannerState {}

/// Represents the success state

class ScannerSuccess extends ScannerState {}

/// Represents an error state with an error message

class ScannerError extends ScannerState {
  ///[message] represents the pretty error returned

  final String message;

  ///[ ScannerError] constructor returning error message to controller class

  ScannerError(this.message);
}
