import 'package:isar/isar.dart';

part 'scanned_card_dto.g.dart';

///
@collection
class ScannedCardDto {
  ///
  Id id = Isar.autoIncrement;

  ///
  int? apiId;

  ///
  String? imagePath;

  ///
  String? deviceId;

  ///
  String? firstName;

  ///
  String? lastName;

  ///
  String? position;

  ///
  String? company;
  
  ///
  String? department;

  ///Added a field for notes
  String? notes;

  ///
  List<String> emails = [];

  ///
  List<String> phones = [];

  ///
  List<String> address = [];

  ///
  List<String> websites = [];

  String get fullName {
    if (firstName != null || lastName != null) {
      return '$firstName $lastName';
    }

    if (company != null) {
      return company!;
    }

    return '';
  }

  @override
  String toString() {
    return 'ScannedCardDto{id: $id apiId: $apiId, imagePath: $imagePath,'
        ' firstName: '
        '$firstName, lastName: $lastName, position: $position, company:'
        ' $company, emails: $emails, phones: $phones, department: $department, '
        'address: $address, websites: $websites, notes: $notes}';
  }
}
