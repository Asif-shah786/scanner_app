import 'dart:io';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

///[DeviceContactsImpService] class
class DeviceContactsImpService {
  // final NetworkService ;

  ///[DeviceContactsImpService] constructor class
  DeviceContactsImpService();

  ///function to fetch user contacts
  Future<List<Contact>> getDeviceContacts() async {
    try {
      if (await FlutterContacts.requestPermission(readonly: true)) {
        final contacts = await FlutterContacts.getContacts(
          withProperties: true,
        );
        return contacts;
      }
      return [];
    } on Exception {
      rethrow;
    }
  }

  ///function to openEditWindow

  static Future<Contact?> openEditWindow(String contactId) async {
    try {
      if (await FlutterContacts.requestPermission(readonly: true)) {
        final contacts = await FlutterContacts.openExternalEdit(contactId);
        return contacts;
      }
      return null;
    } on Exception {
      rethrow;
    }
  }

  ///function to delete Contact

  static Future<bool> deleteContact(String contactId) async {
    try {
      if (await FlutterContacts.requestPermission(readonly: true)) {
        final contact = await FlutterContacts.getContact(contactId);

        if (contact != null) {
          await FlutterContacts.deleteContact(contact);
          return true;
        }
      }

      return false;
    } on Exception {
      rethrow;
    }
  }

  ///function to openContactView

  static Future<Contact?> openContactView(String contactId) async {
    try {
      if (await FlutterContacts.requestPermission(readonly: true)) {
        final contacts = await FlutterContacts.openExternalView(contactId);
      }
      return null;
    } on Exception {
      rethrow;
    }
  }

  ///function to addContact
  static Future<Contact?> addContact(Contact contact) async {
    try {
      if (await FlutterContacts.requestPermission()) {
        final contacts = await contact.insert();
        return contacts;
      }
      return null;
    } on Exception {
      rethrow;
    }
  }

  ///function to openContactView

  static Future<void> shareContact(String contactId) async {
    try {
      final contact = await FlutterContacts.getContact(contactId);
      await Share.share(
        contact?.toVCard() ?? '',
        subject: 'Contact Information',
      );
    } on Exception {
      rethrow;
    }
  }

  static void shareVCFCard(String contactId) async {
    final contact = await FlutterContacts.getContact(contactId);

    final info = contact;
    if (info != null) {
      try {
        final data = contact?.toVCard();
        var vcf = await _createFile(data!);
        await _readFile();
        vcf = await _changeExtenstion('.vcf');
        if (vcf != null) {
          await Share.shareXFiles([XFile(vcf.path)]);
          // ShareExtend.share(_vcf.path, "file");
        }
      } catch (e) {
        return null;
      }
    }
  }

  static Future<String> _readFile() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/contact.txt');
  }

  static Future<File> _createFile(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

  static Future<File> _changeExtenstion(String ext) async {
    final file = await _localFile;
    final newFile = file.renameSync(file.path.replaceAll('.txt', ext));
    return newFile;
  }
}
